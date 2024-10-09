module Com
  class Panel::PgPublicationsController < Panel::BaseController

    def index
      @pg_publications = PgPublication.page(params[:page])
    end

  end
end
