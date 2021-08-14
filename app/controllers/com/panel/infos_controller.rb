module Com
  class Panel::InfosController < Panel::BaseController
    before_action :set_info, only: [:show, :edit, :update, :destroy]

    def index
      @infos = Info.page(params[:page])
    end

    def new
      @info = Info.new
    end

    def create
      @info = Info.new(info_params)

      unless @info.save
        render :new, locals: { model: @info }, status: :unprocessable_entity
      end
    end

    private
    def set_info
      @info = Info.find(params[:id])
    end

    def info_params
      params.fetch(:info, {}).permit(
        :code,
        :value,
        :version,
        :platform
      )
    end

  end
end
