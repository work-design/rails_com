module Com
  module Model::MetaColumn
    extend ActiveSupport::Concern

    included do
      attribute :record_name, :string, index: true
      attribute :column_name, :string
      attribute :sql_type, :string
      attribute :column_type, :string
      attribute :column_limit, :integer

      belongs_to :meta_models, foreign_key: :record_name, primary_key: :record_name
    end

  end
end
