module Com
  class DestroyJob < ApplicationJob

    def perform(record)
      record.destroy
    end

  end
end
