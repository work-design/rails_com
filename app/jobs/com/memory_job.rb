module Com
  class MemoryJob < ApplicationJob

    def perform
      Open3.popen2e('')
    end

  end
end
