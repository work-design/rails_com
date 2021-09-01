module Com
  class Panel::AcmeAccountsController < Panel::BaseController
    before_action :set_acme_account, only: [:show, :edit, :update, :destroy]

    def index
      @acme_accounts = AcmeAccount.page(params[:page])
    end

    def new
      @acme_account = AcmeAccount.new
    end

    def create
      @acme_account = AcmeAccount.new(acme_account_params)

      unless @acme_account.save
        render :new, locals: { model: @acme_account }, status: :unprocessable_entity
      end
    end

    private
    def set_acme_account
      @acme_account = AcmeAccount.find(params[:id])
    end

    def acme_account_params
      params.fetch(:acme_account, {}).permit(
        :email
      )
    end

  end
end
