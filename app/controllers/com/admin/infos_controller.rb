class Com::Admin::InfosController < Com::Admin::BaseController
  before_action :set_info, only: [:show, :edit, :update, :destroy]

  def index
    @infos = Info.page(params[:page])
  end

  def new
    @info = Info.new
  end

  def create
    @info = Info.new(info_params)

    if @info.save
      redirect_to admin_infos_url, notice: 'Info was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @info.update(info_params)
      redirect_to admin_infos_url, notice: 'Info was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @info.destroy
    redirect_to admin_infos_url, notice: 'Info was successfully destroyed.'
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
