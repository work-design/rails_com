module Com
  class SessionChannel < ApplicationCable::Channel

    def subscribed
      if verified_receiver.is_a?(Auth::AuthorizedToken)
        stream_from "com:session:#{verified_receiver.identity}"
      else
        stream_from "com:session:#{verified_receiver}"
      end
    end

    def unsubscribed
    end

  end
end
