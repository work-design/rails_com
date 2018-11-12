module ActiveRecord::Type
  class I18n < Json

    def type
      :i18n
    end

    def deserialize(value)
      @i18n = super
      @i18n[::I18n.locale.to_s]
    end

    def serialize(value)
      value = @i18n.merge(::I18n.locale.to_s => value)
      super
    end

  end
end
