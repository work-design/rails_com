module Com
  module Controller::Admin
    extend ActiveSupport::Concern

    included do
      helper_method :permit_keys
    end

    def index
      instance_variable_set "@#{controller_name.pluralize}", model_klass.page(params[:page])
    end

    def new
      instance_variable_set "@#{model_name}", model_klass.new
    end

    def create
      instance_variable_set "@#{model_name}", model_klass.new(model_params)
      model = model_object

      if model.save
        render :create, status: :created
      else
        render :new, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def update
      model = model_object
      model.assign_attributes(model_params)

      if model.save
        render :update
      else
        render :edit, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def show
      model = model_object
      render :show, locals: { model: model }
    end

    def edit
      model = model_object
      render :edit, locals: { model: model }
    end

    def move_higher
      model = model_object
      model.move_higher
    end

    def move_lower
      model = model_object
      model.move_lower
    end

    def destroy
      model = model_object
      model.destroy
    end

    private
    def model_klass
      self.class.root_module.const_get(controller_name.classify)
    end

    def model_object
      if instance_variable_defined? "@#{model_name}"
        instance_variable_get "@#{model_name}"
      else
        instance_variable_set "@#{model_name}", model_klass.find(params[:id])
      end
    end

    def model_name
      controller_name.singularize
    end

    def model_params
      r = permit_keys
      params.fetch("#{model_name}", {}).permit(*r)
    end

    # todo, 如果 super controller 定义了同名，则将参数进行 & 操作。
    def permit_keys
      if self.class.private_method_defined?("#{model_name}_permit_params") || self.class.method_defined?("#{model_name}_permit_params")
        send("#{model_name}_permit_params").map(&:to_s)
      else
        model_klass.column_names - ['id', 'created_at', 'updated_at']
      end
    end

  end
end
