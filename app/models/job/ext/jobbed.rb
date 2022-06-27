module Job
  module Ext::Jobbed
    extend ActiveSupport::Concern

    included do
      attribute :job_id, :string

      has_one :job, class_name: 'GoodJob::Job', primary_key: :job_id, foreign_key: :active_job_id
      has_one :execution, ->{ order(created_at: :asc) }, class_name: 'GoodJob::Execution', primary_key: :job_id, foreign_key: :active_job_id
      has_many :executions, class_name: 'GoodJob::Execution', primary_key: :job_id, foreign_key: :active_job_id
    end

  end
end
