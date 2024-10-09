module Com
  class Panel::PgPublicationsController < Panel::BaseController

    def index
      @pg_publications = PgPublication.page(params[:page])
    end

    def new
      PgPublication.connection.execute "CREATE PUBLICATION #{} FOR TABLE #{}"
    end

  end
end
