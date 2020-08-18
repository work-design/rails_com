module RailsCom::MailExt

  def from
    r = super
    if r.is_a?(String)
      r.encode('utf-8', replace: '')
    elsif r.is_a?(Array)
      r.join(',').encode('utf-8', replace: '')
    else
      super
    end
  end

  def to
    r = super
    if r.is_a?(String)
      r.encode('utf-8', replace: '')
    elsif r.is_a?(Array)
      r.join(',').encode('utf-8', replace: '')
    else
      super
    end
  end

  def subject
    super.encode('utf-8', replace: '')
  end

end

require 'mail'
Mail::Message.prepend RailsCom::MailExt
