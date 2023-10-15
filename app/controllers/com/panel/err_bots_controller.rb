module Com
  class Panel::ErrBotsController < Panel::BaseController
    before_action :set_err_bot, only: [:show, :destroy]

    def index
      q_params = {}

      @err_bots = ErrBot.page(params[:page])
    end

    private
    def set_err_bot
      @err_bot = ErrBot.find(params[:id])
    end

  end
end
