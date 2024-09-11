module RailsCom::SolidQueue
  module Include
    extend ActiveSupport::Concern

    included do
      scope :todo, -> { default_where('scheduled_at-gte': Time.current) }
      scope :lost, -> { default_where('scheduled_at-lt': Time.current) }

      after_save_commit :job_done, if: -> { saved_change_to_finished_at? }
    end

    def job_done
      broadcast_action_to(
        self,
        action: :replace,
        target: 'job_done',
        partial: "#{class_name.underscore}/job_done",
        locals: { model: self }
      )
    end

  end
end

ActiveSupport.on_load :solid_queue_job do
  include RailsCom::SolidQueue::Include
end