module RailsCom::SolidQueue
  module Include
    extend ActiveSupport::Concern

    included do
      scope :todo, -> { default_where('scheduled_at-gte': Time.current) }
      scope :lost, -> { default_where('scheduled_at-lt': Time.current) }
    end

  end
end

ActiveSupport.on_load :solid_queue_record do
  SolidQueue::Job.include RailsCom::SolidQueue::Include
end