module Com
  module Model::Filter
    extend ActiveSupport::Concern

    included do
      attribute :controller_path, :string, null: false
      attribute :action_name, :string
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :filter_columns, dependent: :delete_all
    end

  end
end
