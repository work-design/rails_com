module ActiveRecord::Type
  class I18n < Json

    def type
      :i18n
    end

    def deserialize(value)
      @result = super
      @result[::I18n.locale.to_s]
    end

    def serialize(value)
      value = @result.merge(::I18n.locale.to_s => value)
      super
    end

  end
end
