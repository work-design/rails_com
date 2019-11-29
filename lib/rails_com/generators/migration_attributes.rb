class RailsCom::MigrationAttributes
  attr_reader :record_class, :new_attributes, :custom_attributes, :new_references
  
  def initialize(record_class)
    @record_class = record_class
    @table_exists = record_class.table_exists?
    @timestamps = true
    set_new_references
    set_new_attributes
    set_custom_attributes
    set_indexes
  end
  
  def to_hash
    r = instance_values.slice('table_exists', 'timestamps', 'indexes', 'new_references', 'new_attributes', 'custom_attributes')
    r.symbolize_keys!
  end

  def table_name
    @table_name = record_class.table_name
  end
  
  def set_new_references
    @new_references = record_class.reflections.values.select { |reflection| reflection.belongs_to? }
    @new_references.reject! { |reflection| record_class.attributes_to_define_after_schema_loads.keys.include?(reflection.foreign_key.to_s) }
    @new_references.reject! { |reflection| record_class.table_exists? && record_class.column_names.include?(reflection.foreign_key.to_s) }
    @new_references.map! do |ref|
      r = { name: ref.name }
      r.merge! polymorphic: true if ref.polymorphic?
      r.merge! reference_options: reference_options(r)
    end
  end
  
  def set_new_attributes
    @new_attributes = record_class.new_attributes
    @new_attributes.map! do |attribute|
      @timestamps = 'updated_at' if attribute[:name].to_s == 'created_at'
      @timestamps = 'created_at' if attribute[:name].to_s == 'updated_at'
      attribute.merge! attribute_options: attribute_options(attribute)
    end
  end
  
  def set_custom_attributes
    if @table_exists
      @custom_attributes = record_class.custom_attributes
      @custom_attributes.map! do |attribute|
        attribute.merge! attribute_options: attribute_options(attribute)
      end
    else
      @custom_attributes = []
    end
  end
  
  def set_indexes
    @indexes = record_class.indexes_to_define_after_schema_loads
    @indexes.map! do |index|
      index.merge! index_options: index_options(index)
    end
  end

  def reference_options(reference)
    reference.slice(:polymorphic).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
  end
  
  def attribute_options(attribute)
    attribute.slice(:limit, :precision, :scale, :comment, :default, :null, :index, :array).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
  end
  
  def index_options(index)
    index.slice(:unique, :name).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
  end

end
