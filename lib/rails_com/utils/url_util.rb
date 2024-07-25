
module UrlUtil
  extend self

  def file_from_url(url)
    file = Tempfile.new
    file.binmode

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
end