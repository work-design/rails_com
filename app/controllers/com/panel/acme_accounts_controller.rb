module Com
  class Panel::AcmeAccountsController < Panel::BaseController

    def index
      @acme_accounts = AcmeAccount.page(params[:page])
    end

    private
    def acme_account_permit_params
      [
        :email
      ]
    end

  end
end
