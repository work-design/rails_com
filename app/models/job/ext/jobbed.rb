module Job
  module Ext::Jobbed
    extend ActiveSupport::Concern

    included do
      attribute :job_id, :string

      belongs_to :job, class_name: 'GoodJob::ActiveJobJob', foreign_key: :job_id, primary_key: :active_job_id, optional: true
    end

  end
end
