class RailsCom::MigrationAttributes

  def set_new_attributes
    @new_attributes = record_class.new_attributes
    @new_attributes.each do |attribute, options|
      if ['created_at', 'updated_at'].include?(attribute.to_s)
        @timestamps.append attribute.to_s
      end
      @new_attributes[attribute].merge! attribute_options: attribute_options(options)
    end
  end

  def set_custom_attributes
    if @table_exists
      @custom_attributes = record_class.custom_attributes
      @custom_attributes.each do |attribute, options|
        @custom_attributes[attribute].merge! attribute_options: attribute_options(options)
      end
    else
      @custom_attributes = {}
    end
  end


end
