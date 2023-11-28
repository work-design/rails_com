module Com
  class Admin::FiltersController < Admin::BaseController
    before_action :set_new_filter, only: [:new, :create, :detect]

    def detect

    end

    private
    def set_new_filter
      @filter = Filter.new(filter_params)
    end

    def filter_params
      params.fetch(:filter, {}).permit(
        :name,
        :controller_path,
        :action_name,
        filter_columns_attributes: [:column, :value]
      )
    end

  end
end
