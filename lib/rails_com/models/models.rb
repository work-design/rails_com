module RailsDoc
  class Models

    def initialize
      @models = models
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
      @models.map { |klass| klass.to_s }
    end

  end
end