module Com
  module Admin

    def create
      model = instance_variable_get "@#{controller_name.singularize}"

      if model.save
        render 'create'
      else
        render action: 'new', locals: { model: model }, status: :unprocessable_entity
      end
    end

    def update
      model = instance_variable_get "@#{controller_name.singularize}"
      model_params = public_send "#{controller_name.singularize}_params"
      model.assign_attributes(model_params)

      if model.save
        render 'update'
      else
        render action: 'edit', locals: { model: model }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def new
    end

    def destroy
      model = instance_variable_get "@#{controller_name.singularize}"
      model.destroy
    end

  end
end
