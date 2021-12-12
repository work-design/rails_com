module JiaBo
  class Panel::TemplatesController < Panel::BaseController
    before_action :set_app
    before_action :set_template, only: [:show, :edit, :update, :destroy]
    before_action :set_new_template, only: [:new, :create]

    def index
      @templates = @app.templates.includes(:parameters).page(params[:page])
    end

    private
    def set_template
      @template = @app.templates.find params[:id]
    end

    def set_new_template
      @template = @app.templates.build template_params
    end

    def set_app
      @app = App.find params[:app_id]
    end

    def template_params
      params.fetch(:template, {}).permit(
        :title,
        :code
      )
    end

  end
end
