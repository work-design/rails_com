module Com
  class Panel::MetaBusinessesController < Panel::BaseController
    before_action :set_meta_business, only: [:show, :edit, :update, :move_higher, :move_lower]

    def index
      @meta_businesses = MetaBusiness.with_attached_logo.order(position: :asc).page(params[:page])
    end

    def sync
      MetaBusiness.sync
    end

    def move_higher
      @meta_business.move_higher
    end

    def move_lower
      @meta_business.move_lower
    end

    private
    def meta_business_params
      [
        :name,
        :logo
      ]
    end

    def set_meta_business
      @meta_business = MetaBusiness.find(params[:id])
    end

  end
end
