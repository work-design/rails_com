module DefaultForm::ActiveRecord
  module Extend

    def input_attributes_by_model
      cols = {}

      attributes_by_model.each do |name, column|
        r = {}
        r.merge! column.slice(:type, :subtype, :outer)
        r.merge! input_type: column[:raw_type]

        if r[:type].respond_to? :input_type
          r.merge! input_type: r[:type].input_type
        end

        if r[:type].respond_to? :subtype
          case r[:type].class.name
          when 'ActiveRecord::Enum::EnumType'
            r.merge! input_type: :enum
            r.merge! mapping: r[:type].send(:mapping)
          end
        end

        if inheritance_column.to_s == name
          r.merge! input_type: :enum
        end

        cols.merge! name => r
      end

      cols
    end

  end
end

ActiveSupport.on_load :active_record do
  extend DefaultForm::ActiveRecord::Extend
end
