module Com
  module Controller::Curd
    extend ActiveSupport::Concern
    include Controller::Actions

    included do
      helper_method :permit_keys, :model_klass, :model_name, :pluralize_model_name
    end

    def index
      if model_klass.column_names.include?('organ_id')
        instance_variable_set "@#{pluralize_model_name}", model_klass.where(default_params).order(id: :asc).page(params[:page]).per(params[:per])
      else
        instance_variable_set "@#{pluralize_model_name}", model_klass.order(id: :asc).page(params[:page]).per(params[:per])
      end
    end

    def debug
      index
    end

    def new
      model = model_new_object
      render :new, locals: { model: model }
    end

    def create
      model = model_new_object

      if model.save
        render :create, locals: { model: model }, status: :created
      else
        render :new, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def batch_destroy
      model_klass.where(id: params[:ids].split(',')).each(&:destroy)
    end

    def update
      model = model_object
      model.assign_attributes(model_params)

      if model.save
        render :update, locals: { model: model }
      else
        render :edit, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def refresh
      model = model_object
      model.assign_attributes(model_params)

      if model.save
        index
        render :refresh
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

    def inline
      model = model_object
      render :inline, locals: { model: model }
    end

    def move_higher
      model = model_object
      model.update position: { before: model.prior_position }
    end

    def move_lower
      model = model_object
      model.update position: { after: model.subsequent_position }
    end

    def reorder
      model = model_object

      if params[:new_index] > params[:old_index] # 向下移动
        model.update position: { after: params[:prior_id] }
      else # 向上移动
        model.update position: { before: params[:subsequent_id] }
      end
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
      elsif params[:id]
        instance_variable_set "@#{model_name}", model_klass.find(params[:id])
      end
    end

    def model_new_object
      if instance_variable_defined? "@#{model_name}"
        instance_variable_get "@#{model_name}"
      else
        instance_variable_set("@#{model_name}", model_klass.new(model_params))
      end
    end

    def pluralize_model_name
      controller_name.pluralize
    end

    def model_params
      if self.class.private_method_defined?("#{model_name}_params") || self.class.method_defined?("#{model_name}_params")
        send "#{model_name}_params"
      else
        model = model_object || model_klass.new
        p = params.fetch(model_name, {}).permit(*permit_keys, **permit_hash)
        p.merge! default_form_params if model.respond_to?(:organ_id)
        p
      end
    end

    # todo, 如果 super controller 定义了同名，则将参数进行 & 操作。
    def permit_keys
      if self.class.private_method_defined?("#{model_name}_permit_params") || self.class.method_defined?("#{model_name}_permit_params")
        model_klass.com_column_names & send("#{model_name}_permit_params").map(&:to_s)
      else
        model_klass.com_column_names
      end
    end

    def permit_hash
      model_klass.com_column_hash
    end

  end
end
