module Com
  class Panel::StatisticConfigsController < Panel::BaseController

    private
    def statistic_config_params
      params.fetch(:statistic_config, {}).permit(
        :statistical_type,
        :statistical_id,
        :note,
        :begin_on,
        :end_on,
        keys: []
      )
    end
  end
end
