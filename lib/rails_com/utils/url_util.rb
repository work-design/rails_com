
module UrlUtil
  extend self

  def file_from_url(url)
    file = Rails.root.join('tmp/files', SecureRandom.alphanumeric)
    file.delete if file.file?
    file.dirname.exist? || file.dirname.mkpath

    begin
      res = HTTPX.plugin(:follow_redirects).get(url)
      res.body.each do |fragment|
        file.binwrite fragment
      end if res.error.nil?
    rescue => e
    end
    file
  end
end