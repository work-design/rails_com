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
      record_classes.each do |record_class|
        r[:table_exists] = r[:table_exists] || record_class.table_exists?
        r[:new_attributes].merge! record_class.defined_attributes_by_model.except(*record_class.defined_attributes_by_db.keys)
        r[:new_references].merge! record_class.defined_references_by_model.except(*record_class.defined_attributes_by_db.keys)
        r[:custom_attributes] ||= record_class.defined_attributes_by_db
        r[:custom_attributes].except!(*record_class.defined_attributes_by_model.keys, *record_class.defined_attributes_by_default, *record_class.defined_attributes_by_belongs)
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
