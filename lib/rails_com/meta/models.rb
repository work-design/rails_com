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

    models.group_by(&:table_name).each do |table_name, record_classes|
      r = @tables[table_name] || {}
      r[:new_attributes] ||= {}
      r[:new_references] ||= {}
      r[:custom_attributes] ||= {}
      record_classes.each do |record_class|
        r[:table_exists] = r[:table_exists] || record_class.table_exists?
        r[:new_attributes].merge! record_class.to_add_attributes
        r[:new_references].merge! record_class.to_add_references
        r[:custom_attributes] = r[:custom_attributes].slice(*(r[:custom_attributes].keys & record_class.to_remove_attributes.keys))
        r[:timestamps] = [:created_at, :updated_at] & r[:new_attributes].keys
        r[:indexes] = record_class.xx_indexes
      end
      @tables[table_name] = r unless r[:new_attributes].blank? && r[:new_references].blank? && r[:custom_attributes].blank? 
    end

    @tables
  end

  def model_names
    models.map(&:to_s)
  end

end
