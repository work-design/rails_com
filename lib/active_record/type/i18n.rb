module ActiveRecord::Type
  class I18n < Json

    def type
      :i18n
    end

    def deserialize(value)
      Thread.current[:i18n] = super
      Thread.current[:i18n][::I18n.locale.to_s]
    end

    def serialize(value)
      value = Thread.current[:i18n].merge(::I18n.locale.to_s => value)
      super
    end

  end
end
