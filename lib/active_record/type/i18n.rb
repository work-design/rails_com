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
        if r.is_a?(Hash)
          value = r.merge(::I18n.locale.to_s => value)
        end
      else
        v = ActiveSupport::JSON.decode(value || '{}')
        if v.is_a?(Hash)
          value = v
        else
          value = { ::I18n.locale.to_s => value }
        end
      end

      super(value)
    end

  end
end

ActiveRecord::Type.register(:i18n, ActiveRecord::Type::I18n)
