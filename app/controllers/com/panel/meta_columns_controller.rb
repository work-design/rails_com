module Com
  class Panel::MetaColumnsController < Panel::BaseController
    before_action :set_new_meta_column, only: [:new, :create]
    before_action :set_meta_column, only: [:show, :edit, :update, :destroy]

    def index
      @meta_columns = MetaColumn.page(params[:page])
    end

    private
    def set_meta_column
      @meta_column = MetaColumn.find(params[:id])
    end

    def set_new_meta_column
      @meta_column = MetaColumn.new(meta_column_params)
    end

    def meta_column_params
      params.fetch(:meta_column, {}).permit(
        :model_name,
        :column_name,
        :column_type,
        :sql_type,
        :column_limit
      )
    end

  end
end
