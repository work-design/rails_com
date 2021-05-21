module RailsCom::Models
  extend self

  def models
    Zeitwerk::Loader.eager_load_all
    result = ActiveRecord::Base.descendants
    result.reject!(&:abstract_class?)
    result
  end

  def tables_hash
    @tables = {}
    models.group_by(&:table_name).each do |table_name, record_class|
      r[:table_exists] = true
      r[:new_attributes] = record_class.to_add_attributes
      r[:new_references] = record_class.to_add_references
      r[:custom_attributes] = record_class.to_remove_attributes
      r[:timestamps] = [:created_at, :updated_at] | r[:new_attributes].keys
      r[:indexes] = record_class.xx_indexes

      if @tables.key? table_name
        @tables[table_name][:new_attributes].merge! r[:new_attributes]
        @tables[table_name][:new_references].merge! r[:new_references]
      else
        @tables[table_name] = r
      end
    end
  end

  def model_names
    models.map(&:to_s)
  end

end
