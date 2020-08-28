class Com::Panel::InfosController < Com::Panel::BaseController
  before_action :set_info, only: %i[show edit update destroy]

  def index
    @infos = Info.page(params[:page])
  end

  def new
    @info = Info.new
  end

  def create
    @info = Info.new(info_params)

    render :new, locals: { model: @info }, status: :unprocessable_entity unless @info.save
  end

  def show
  end

  def edit
  end

  def update
    @info.assign_attributes(info_params)

    render :edit, locals: { model: @info }, status: :unprocessable_entity unless @info.save
  end

  def destroy
    @info.destroy
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
