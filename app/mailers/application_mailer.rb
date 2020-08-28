unless defined? ApplicationMailer
  class ApplicationMailer < ActionMailer::Base
    layout 'mailer'
  end
end
