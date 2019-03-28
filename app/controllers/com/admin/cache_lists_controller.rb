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

    respond_to do |format|
      if @cache_list.save
        format.html.phone
        format.html { redirect_to admin_cache_lists_url, notice: 'Cache list was successfully created.' }
        format.js { redirect_back fallback_location: admin_cache_lists_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: admin_cache_lists_url }
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @cache_list.assign_attributes(cache_list_params)

    respond_to do |format|
      if @cache_list.save
        format.html.phone
        format.html { redirect_to admin_cache_lists_url, notice: 'Cache list was successfully updated.' }
        format.js { redirect_back fallback_location: admin_cache_lists_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_cache_lists_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @cache_list.destroy
    redirect_to admin_cache_lists_url, notice: 'Cache list was successfully destroyed.'
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
