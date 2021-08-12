module Com
  module Controller::Admin

    def new
    end

    def create
      model = instance_variable_get "@#{controller_name.singularize}"

      if model.save
        render :create, status: :created
      else
        render :new, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def update
      model = instance_variable_get "@#{controller_name.singularize}"
      model_params = send "#{controller_name.singularize}_params"
      model.assign_attributes(model_params)

      if model.save
        render :update
      else
        render :edit, locals: { model: model }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def move_higher
      model = instance_variable_get "@#{controller_name.singularize}"
      model.move_higher
    end

    def move_lower
      model = instance_variable_get "@#{controller_name.singularize}"
      model.move_lower
    end

    def destroy
      model = instance_variable_get "@#{controller_name.singularize}"
      model.destroy
    end

  end
end
