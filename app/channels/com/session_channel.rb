module Com
  class SessionChannel < ApplicationCable::Channel

    def subscribed
      if defined?(Auth::AuthorizedToken) && verified_receiver.is_a?(Auth::AuthorizedToken)
        verified_receiver.update online: true
        stream_from "com:session:#{verified_receiver.identity}"
      else
        stream_from "com:session:#{verified_receiver}"
      end
    end

    def unsubscribed
      if defined?(Auth::AuthorizedToken) && verified_receiver.is_a?(Auth::AuthorizedToken)
        verified_receiver.update online: false
      end
    end

  end
end
