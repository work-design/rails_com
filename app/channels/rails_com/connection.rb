module RailsCom::Connection
  extend ActiveSupport::Concern
  included do
    identified_by :current_receiver
  end

  def connect
    self.current_receiver = find_verified_receiver
    logger.debug "==========> Current Receiver: #{current_receiver.class}:#{current_receiver.id}" if current_receiver
  end
  
  protected
  def find_verified_receiver
    if session && session['receiver_id'] && session['receiver_type']
      Rails.logger.silence do
        session['receiver_type'].constantize.find session['receiver_id']
      end
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
