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
    return unless session
    if session['auth_token'] && defined?(Auth::AuthorizedToken)
      Rails.logger.silence do
        r = Auth::AuthorizedToken.find_by(id: session['auth_token'])
        return r if r&.user
      end
    end

    session['session_id']
  rescue
    logger.error 'An unauthorized connection attempt was rejected'
    nil
  end

  def session
    session_key = Rails.configuration.session_options[:key]
    cookies.encrypted[session_key]
  end

end
