
module UrlUtil
  extend self

  def file_from_url(url, filename: SecureRandom.alphanumeric)
    file_path = Rails.root.join('tmp/files', filename)
    file_path.dirname.exist? || file_path.dirname.mkpath
    file = File.new(file_path, 'w')

    begin
      res = HTTPX.plugin(:follow_redirects).get(url)
      res.body.each do |fragment|
        file.binwrite fragment
      end if res.error.nil?
    rescue => e
    end
    file.rewind
    file_path
  end
end