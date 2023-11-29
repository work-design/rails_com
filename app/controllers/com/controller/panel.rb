module Com
  module Controller::Panel
    extend ActiveSupport::Concern
    include Controller::Curd

    def index
      instance_variable_set "@#{pluralize_model_name}", model_klass.order(id: :asc).page(params[:page])
    end

    private
    def model_params
      if self.class.private_method_defined?("#{model_name}_params") || self.class.method_defined?("#{model_name}_params")
        send "#{model_name}_params"
      else
        params.fetch(model_name, {}).permit(*permit_keys, **permit_hash)
      end
    end

  end
end
