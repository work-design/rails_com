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
      r[:add_attributes] ||= {}
      r[:add_references] ||= {}
      record_classes.each do |record_class|
        r[:table_exists] = r[:table_exists] || record_class.table_exists?
        r[:add_attributes].merge! record_class.defined_attributes_by_model.except(*record_class.defined_attributes_by_db.keys)
        r[:add_references].merge! record_class.defined_references_by_model.except(*record_class.defined_attributes_by_db.keys)
        r[:remove_attributes] ||= record_class.defined_attributes_by_db
        r[:remove_attributes].except!(*record_class.defined_attributes_by_model.keys, *record_class.defined_attributes_by_default, *record_class.defined_attributes_by_belongs)
        r[:timestamps] = ['created_at', 'updated_at'] & r[:add_attributes].keys
        r[:indexes] = record_class.xx_indexes
      end

      @tables[table_name] = r unless r[:add_attributes].blank? && r[:add_references].blank? && r[:remove_attributes].blank?
    end

    @tables
  end

  def modules_hash
    @modules = {}

    models.group_by(&:module_parent).each do |module_name, record_classes|
      new_prefix = (module_name.respond_to?(:table_name_prefix) && module_name.table_name_prefix) || ''
      old_prefix = (module_name.respond_to?(:old_table_name_prefix) && module_name.old_table_name_prefix) || ''

      record_classes.each do |record_class|
        unless record_class.table_exists?
          possible = record_class.table_name.sub(/^#{new_prefix}/, old_prefix)
          @modules.merge! record_class.table_name => possible if tables.any?(possible)
        end
      end
    end

    arr = @modules.values
    result = arr.find_all { |e| arr.rindex(e) != arr.index(e) }
    warn "Please check #{result}"

    @modules
  end

  def unbound_tables
    tables - models.map(&:table_name) - ['schema_migrations', 'ar_internal_metadata']
  end

  def tables
    ActiveRecord::Base.connection.tables
  end

  def model_names
    models.map(&:to_s)
  end

end
