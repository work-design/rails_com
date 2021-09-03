module Com
  class Panel::InfosController < Panel::BaseController

    def index
      @infos = Info.order(id: :asc).page(params[:page])
    end

  end
end
