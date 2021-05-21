module RailsCom::Models
  extend self

  def xx
    Zeitwerk::Loader.eager_load_all
    tables = ActiveRecord::Base.descendants
    tables.reject!(&:abstract_class?)
    tables
  end

  def zz
    xx.group_by(&:table_name)
  end

  def models
    models = ActiveRecord::Base.connection.tables.map do |table|
      begin
        klass = table.classify.constantize
        klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
      rescue
        nil
      end
    end

    models.compact
  end

  def model_names
    models.map(&:to_s)
  end

end
