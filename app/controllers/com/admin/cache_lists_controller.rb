class Com::Admin::CacheListsController < Com::Admin::BaseController
  before_action :set_cache_list, only: [:show, :edit, :update, :destroy]

  def index
    @cache_lists = CacheList.page(params[:page])
  end

  def new
    @cache_list = CacheList.new
  end

  def create
    @cache_list = CacheList.new(cache_list_params)
    
    unless @cache_list.save
      render :new, locals: { model: @cache_list }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @cache_list.assign_attributes(cache_list_params)
    
    unless @cache_list.save
      render :edit, locals: { model: @cache_list }, status: :unprocessable_entity
    end
  end

  def destroy
    @cache_list.destroy
    redirect_to admin_cache_lists_url
  end

  private
  def set_cache_list
    @cache_list = CacheList.find(params[:id])
  end

  def cache_list_params
    params.fetch(:cache_list, {}).permit(
      :path,
      :key
    )
  end

end
