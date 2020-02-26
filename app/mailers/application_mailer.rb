class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
end unless defined? ApplicationMailer
