module Com
  class SessionChannel < ApplicationCable::Channel

    def subscribed
      if defined?(Auth::AuthorizedToken) && verified_receiver.is_a?(Auth::AuthorizedToken)
        verified_receiver.update online_at: Time.current, offline_at: nil
        stream_from "com:session:#{verified_receiver.identity}"
      else
        stream_from "com:session:#{verified_receiver}"
      end
    end

    def unsubscribed
      if defined?(Auth::AuthorizedToken) && verified_receiver.is_a?(Auth::AuthorizedToken)
        verified_receiver.update online_at: nil, offline_at: Time.current
      end
    end

  end
end
