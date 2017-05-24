module QiniuHelper
  extend self
  
  def download_url(key)
    Qiniu::Auth.authorize_download_url_2(config['host'], key)
  end

  def qiniu_url(key)
    config['host'] << '/' unless config['host'].end_with? '/'
    config['host'] + key.to_s
  end

  def generate_uptoken(key = nil, **options)
    put_policy = Qiniu::Auth::PutPolicy.new(config['bucket'], key)
    options.slice(*Qiniu::Auth::PutPolicy::PARAMS.keys).each do |k, v|
      put_policy.send(k.to_s + '=', v)
    end
    binding.pry
    @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
  end

  def upload(local_file, key = nil, **options)
    code, result, response_headers = upload_verbose(local_file, key, options)
    result['key']
  end

  def upload_verbose(local_file, key = nil, **options)
    code, result, response_headers = Qiniu::Storage.upload_with_token_2(
      generate_uptoken(key, options),
      local_file,
      key,
      nil,
      bucket: config['bucket']
    )
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