
module UrlUtil
  extend self

  def from_url(url, filename: SecureRandom.alphanumeric)
    _, file = init_file(filename)
    fetch_file(url, file)
    file
  end

  def file_from_url(url, filename: SecureRandom.alphanumeric)
    _, file = init_file(filename)
    fetch_file(url, file)
    file.rewind
    file
  end

  def filepath_from_url(url, filename: SecureRandom.alphanumeric)
    file_path, file = init_file(filename)
    fetch_file(url, file)
    file.rewind
    file_path
  end

  private
  def fetch_file(url, file)
    res = HTTPX.plugin(:follow_redirects).get(url)
    if res.error.nil?
      res.body.each do |fragment|
        file.write fragment
      end
    end
  rescue => e
  end

  def init_file(filename)
    file_path = Rails.root.join('tmp/files', filename)
    file_path.dirname.exist? || file_path.dirname.mkpath
    file = File.new(file_path, 'w')
    file.binmode
    [file_path, file]
  end
end