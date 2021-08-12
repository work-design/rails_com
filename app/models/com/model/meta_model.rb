module Com
  module Model::MetaModel
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :record_name, :string, index: true
      attribute :description, :string

      has_many :meta_columns, foreign_key: :record_name, primary_key: :record_name, inverse_of: :meta_model
    end

    class_methods do

      def sync
        RailsCom::Models.models.each do |model|
          next unless model.table_exists?
          meta_model = self.find_or_initialize_by(record_name: model.name)

          model.columns.each do |column|
            meta_column = meta_model.meta_columns.find_or_initialize_by(column_name: column.name)
            meta_column.column_type = column.type
            meta_column.sql_type = column.sql_type
            meta_column.column_limit = column.limit
            meta_column.comment = column.comment

            present_meta_columns = meta_model.meta_columns.pluck(:column_name)
            meta_model.meta_columns.select(&->(i){ (present_meta_columns - model.column_names).include?(i.column_name) }).each do |needless_column|
              needless_column.mark_for_destruction
            end
          end
          meta_model.save if meta_model.meta_columns.length > 0

          present_models = self.pluck(:record_name)
          self.where(record_name: (present_models - RailsCom::Models.model_names)).each do |needless_model|
            needless_model.destroy
          end
        end
      end

    end

  end
end
