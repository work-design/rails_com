module Com
  module Model::MetaColumn
    extend ActiveSupport::Concern

    included do
      attribute :record_name, :string, index: true
      attribute :column_name, :string
      attribute :sql_type, :string
      attribute :column_type, :string
      attribute :column_limit, :integer
      attribute :comment, :string

      belongs_to :meta_model, foreign_key: :record_name, primary_key: :record_name
    end

  end
end
