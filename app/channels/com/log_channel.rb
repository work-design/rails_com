module Com
  class LogChannel < ApplicationCable::Channel

    def subscribed
      stream_from "com:log:#{verified_receiver.id}"
    end

  end
end
