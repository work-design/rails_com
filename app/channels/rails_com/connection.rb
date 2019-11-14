module RailsCom::Connection
  extend ActiveSupport::Concern
  included do
    identified_by :verified_receiver
  end

  def connect
    self.verified_receiver = find_verified_receiver
  end
  
  protected
  def find_verified_receiver
    if session && session['auth_token']
      Rails.logger.silence do
        AuthorizedToken.find_by token: session['auth_token']
      end
    else
      session['session_id']
    end
  rescue
    logger.error 'An unauthorized connection attempt was rejected'
    nil
  end
  
  def session
    session_key = Rails.configuration.session_options[:key]
    cookies.encrypted[session_key]
  end

end
