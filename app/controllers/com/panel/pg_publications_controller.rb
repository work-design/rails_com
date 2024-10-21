module Com
  class Panel::PgPublicationsController < Panel::BaseController
    before_action :set_tables
    before_action :set_pg_publication, only: [:show, :edit, :update, :destroy]

    def index
      @pg_publications = PgPublication.page(params[:page])
    end

    def new
      @pg_publication = PgPublication.new
    end

    def create
      allow_tables = @tables & pg_publication_params[:tables].compact_blank!
      PgPublication.connection.exec_query "CREATE PUBLICATION #{pg_publication_params[:pubname]} FOR TABLE #{allow_tables.join(', ')}"
    end

    def create_all
      PgPublication.connection.exec_query 'CREATE PUBLICATION FOR ALL TABLES'
    end

    def update
      allow_tables = @tables & pg_publication_params[:tables].compact_blank!
      PgPublication.connection.exec_query "ALTER PUBLICATION #{@pg_publication.pubname} SET TABLE #{allow_tables.join(', ')}"
    end

    private
    def set_tables
      @tables = ApplicationRecord.connection.tables
    end

    def set_pg_publication
      @pg_publication = PgPublication.find(params[:id])
    end

    def pg_publication_params
      params.fetch(:pg_publication, {}).permit(
        :pubname,
        tables: []
      )
    end

  end
end
