module Roled
  module Model::WhoRole::WhoJobTitleRole
    extend ActiveSupport::Concern

    included do
      belongs_to :role, class_name: 'JobTitleRole'
    end

  end
end
