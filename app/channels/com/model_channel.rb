module Com
  class ModelChannel < ApplicationCable::Channel

    def subscribed
      stream_from "model:#{verified_receiver.identity}"
    end

    def unsubscribed
    end

  end
end
