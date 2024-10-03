
module UrlUtil
  extend self

  def file_from_url(url, filename: SecureRandom.alphanumeric)
    _, file = init_file(filename)
    xx(file, url)
  end

  def filepath_from_url(url, filename: SecureRandom.alphanumeric)
    file_path, file = init_file(filename)
    xx(file, url)
    file_path
  end

  def xx(file, url)
    begin
      res = HTTPX.plugin(:follow_redirects).get(url)
      res.body.each do |fragment|
        file.write fragment
      end if res.error.nil?
    rescue => e
    end
    file.rewind
    file
  end

  def init_file(filename = SecureRandom.alphanumeric)
    file_path = Rails.root.join('tmp/files', filename)
    file_path.dirname.exist? || file_path.dirname.mkpath
    file = File.new(file_path, 'w')
    file.binmode
    [file_path, file]
  end
end