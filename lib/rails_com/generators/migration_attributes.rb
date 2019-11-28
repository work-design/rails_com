class RailsCom::MigrationAttributes
  attr_reader :record_class
  
  def initialize(record_class)
    @record_class = record_class
    @table_exists = record_class.table_exists?
    set_belongs_to_reflections!
    set_inject_options
  end
  
  def set_belongs_to_reflections!
    @todo_references = record_class.reflections.values.select { |reflection| reflection.belongs_to? }.map do |ref|
      {
        name: ref.name
      }
    end
  end
  
  def table_name
    record_class.table_name
  end
  
  def set_new_attributes
    @new_attributes = record_class.new_attributes
    @new_attributes.map! do |attribute|
      attribute.merge! inject_options: inject_options(attribute)
    end
  end
  
  def set_custom_attributes
    @custom_attributes = record_class.custom_attributes
    @custom_attributes.map! do |attribute|
      attribute.merge! inject_options: inject_options(attribute)
    end
  end
  
  def inject_options(attribute)
    attribute.slice(:limit, :precision, :scale, :comment, :default, :null, :index).inject('') { |s, h| s << ", #{h[0]}: #{h[1].inspect}" }
  end
  
end
