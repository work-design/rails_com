module ActiveRecord::Type
  class I18n < Json

    def type
      :i18n
    end

    def deserialize(value)
      if super.respond_to?(:[])
        super[::I18n.locale.to_s]
      else
        super
      end
    end

    def serialize(value, old_value = nil)
      if old_value
        begin
          r = ActiveSupport::JSON.decode(old_value)
        rescue
          r = {}
        end
      else
        r = {}
      end

      begin
        v = ActiveSupport::JSON.decode(value)
      rescue
        v = value
      end

      binding.pry
      if v.present? && v.is_a?(Hash)
        value = v
      else
        value = { ::I18n.locale.to_s => v }
      end

      binding.pry
      value = r.merge(::I18n.locale.to_s => value)

      super(value)
    end

  end
end

ActiveRecord::Type.register(:i18n, ActiveRecord::Type::I18n)
