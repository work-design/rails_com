module QiniuHelper
  extend self
  
  def download_url(key)
    Qiniu::Auth.authorize_download_url_2(config['host'], key)
  end

  def qiniu_url(key)
    config['host'] << '/' unless config['host'].end_with? '/'
    config['host'] + key.to_s
  end

  def generate_uptoken(key = nil)
    put_policy = Qiniu::Auth::PutPolicy.new(config['bucket'], key)
    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
  end

  def upload(local_file, key = nil)
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
      generate_uptoken(key),
      local_file,
      key,
      nil,
      bucket: config['bucket']
    )
    result['key']
  end

  def delete(key)
    code, result, response_headers = Qiniu::Storage.delete(
      config['bucket'],
      key
    )
    code
  end

  def list(prefix = '')
    list_policy = Qiniu::Storage::ListPolicy.new(config['bucket'], 10, prefix, '/')
    code, result, response_headers, s, d = Qiniu::Storage.list(list_policy)
    result['items']
  end

  def bsearch_last(prefix = '')
    ary = (0..9).to_a.reverse
    search = prefix
    begin_index = 0
    end_index = ary.length - 1
    result = nil

    while true do
      if end_index - begin_index > 1
        index = ((begin_index + end_index) / 2.0).floor
        end_flag = false
      else
        index = end_index
        end_flag = true
      end

      search.sub! /\d$/, ary[index].to_s
      list = self.list(search)

      puts 'index: ' + index.to_s
      puts 'search: ' + search
      puts 'count: ' + list.size.to_s
      puts '-------------'

      if list.blank?
        begin_index = index
      elsif list.size >= 1
        end_index = index

        if end_flag
          search << '9'
          begin_index = 0
          end_index = ary.length - 1

          if list.size == 1
            break result = list[0]['key']
          end
        end
      end
    end

    result
  end

  def last(prefix = '')
    ary = (0..9).to_a.reverse
    search = prefix
    result = nil

    while true do
      break result if result
      ary.each_with_index do |value, index|
        search.sub! /\d$/, value.to_s
        list = self.list(search)

        puts 'index: ' + index.to_s
        puts 'search: ' + search
        puts 'count: ' + list.size.to_s
        puts '-------------'

        if list.blank?
          next
        elsif list.size > 1
          search << '9'
          break
        elsif list.size == 1
          break result = list[0]['key']
        end
      end
    end

    result
  end

  def config
    @config ||= Rails.application.config_for('qiniu')
  end

end