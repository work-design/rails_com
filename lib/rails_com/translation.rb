module RailsCom::I18n
  extend ActiveSupport::Concern

  included do
    before_update :update_i18n_column
    before_create :new_i18n_column
  end

  def update_i18n_column
    str = []
    self.changes.slice(*i18n_attributes).each do |key, value|
      str << "#{key} = jsonb_set(#{key}, '{#{I18n.locale}}', '\"#{value[1]}\"', true)"
    end
    s = str.join(' AND ')
    self.class.connection.execute "UPDATE #{self.class.table_name} SET #{s} WHERE id = #{self.id}"
  end

end

module RailsCom::Translation

  # name
  # * store as jsonb in database;
  # * read with i18n scope
  def has_translations(*columns)
    mattr_accessor :i18n_attributes
    self.i18n_attributes = columns.map(&:to_s)
    include RailsCom::I18n
    columns.each do |column|
      attribute column, :i18n

      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1

        def #{column}=(value)
          if value.is_a?(String)
            super(::I18n.locale => value)
          else
            super
          end
        end

      RUBY_EVAL
    end

  end

  def _substitute_values(values)
    super values.slice(*i18n_attributes)
  end

end

ActiveSupport.on_load :active_record do
  extend RailsCom::Translation
end
