module RailsCom::MailExt

  def from
    super.encode('utf-8', replace: '')
  end

  def to
    super.encode('utf-8', replace: '')
  end

  def subject
    super.encode('utf-8', replace: '')
  end

end

require 'mail'
Mail::Message.prepend RailsCom::MailExt
