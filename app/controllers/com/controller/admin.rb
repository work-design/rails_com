module Com
  module Controller::Admin
    extend ActiveSupport::Concern

    included do
      helper_method :permit_keys, :model_klass, :model_name
    end

    def index
      if model_klass.column_names.include?('organ_id')
        instance_variable_set "@#{controller_name.pluralize}", model_klass.where(default_params).order(id: :asc).page(params[:page]).per(params[:per])
      else
        instance_variable_set "@#{controller_name.pluralize}", model_klass.order(id: :asc).page(params[:page]).per(params[:per])
      end
    end

    def new
      model = model_new_object
      render :new, locals: { model: model }
    end

    def create
      model = model_new_object

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

    def actions
      model = model_object
      render :actions, locals: { model: model }
    end

    def move_higher
      model = model_object
      model.move_higher
    end

    def move_lower
      model = model_object
      model.move_lower
    end

    def reorder
      model = model_object
      sort_array = params[:sort_array].select { |i| i.integer? }

      if params[:new_index] > params[:old_index]
        prev_one = model.class.find(sort_array[params[:new_index].to_i - 1])
        model.insert_at prev_one.position
      else
        next_ones = model.class.find(sort_array[(params[:new_index].to_i + 1)..params[:old_index].to_i])
        next_ones.each do |next_one|
          next_one.insert_at model.position
        end
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

    def model_name
      controller_name.singularize
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
