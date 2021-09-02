module Com
  class Panel::CacheListsController < Panel::BaseController
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

    private
    def set_cache_list
      @cache_list = CacheList.find(params[:id])
    end

    def cache_list_permit_params
      [
        :path,
        :key
      ]
    end

  end
end
