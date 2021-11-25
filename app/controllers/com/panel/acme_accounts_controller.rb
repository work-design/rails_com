module Com
  class Panel::AcmeAccountsController < Panel::BaseController

    private
    def acme_account_permit_params
      [
        :email,
        :ali_key,
        :ali_secret
      ]
    end

  end
end
