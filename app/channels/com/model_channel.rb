module Com
  class ModelChannel < ApplicationCable::Channel

    def subscribed
      stream_from "model:#{connection_identifier}"
    end

    def unsubscribed
    end

  end
end
