
module UrlUtil
  extend self

  def from_url(url, filename: SecureRandom.alphanumeric, root: Rails.root.join('tmp/files'))
    _, file = init_file(filename, root: root)
    fetch_file(url, file)
    file
  end

  def file_from_url(url, filename: SecureRandom.alphanumeric, root: Rails.root.join('tmp/files'))
    _, file = init_file(filename, root: root)
    fetch_file(url, file)
    file.rewind
    file
  end

  def filepath_from_url(url, filename: SecureRandom.alphanumeric, root: Rails.root.join('tmp/files'))
    file_path, file = init_file(filename, root: root)
    fetch_file(url, file)
    file.rewind
    file_path
  end

  def init_file(filename = SecureRandom.alphanumeric, root:)
    file_path = root.join(filename)
    file_path.dirname.exist? || file_path.dirname.mkpath
    file = File.new(file_path, 'w+')
    file.binmode
    [file_path, file]
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

end