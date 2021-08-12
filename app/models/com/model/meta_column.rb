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
      attribute :defined_db, :boolean, default: false
      attribute :defined_model, :boolean, default: false

      belongs_to :meta_model, foreign_key: :record_name, primary_key: :record_name
    end

    def sync
      unless record_class.column_names.include?(self.column_name)
        record_class.connection.add_column(record_class.table_name, column_name, column_type)
        record_class.reset_column_information
      end
    end

    def test
      record_class.update self.column_name => 'ss'
    end

    def record_class
      record_name.constantize
    end

  end
end
