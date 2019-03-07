module RailsCom::Models
  extend self

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
