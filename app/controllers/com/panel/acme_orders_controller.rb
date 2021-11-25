module Com
  class Panel::AcmeOrdersController < Panel::BaseController
    before_action :set_acme_account
    before_action :set_acme_order, only: [:show, :edit, :order, :verify, :cert, :update, :destroy]
    before_action :set_new_acme_account, only: [:create]

    def index
      q_params = {
        acme_account_id: @acme_account.id
      }
      q_params.merge! params.permit(:acme_account_id)

      @acme_orders = AcmeOrder.default_where(q_params).order(id: :desc).page(params[:page])
    end

    def new
      @acme_order = @acme_account.acme_orders.build
      @acme_order.acme_identifiers.build
    end

    def order
      r = @acme_order.order(true)

      render 'update'
    end

    def verify
      r = @acme_order.all_verify?

      render 'update'
    end

    def cert
      r = @acme_order.finalize
      @acme_order.cert

      render 'update'
    end

    private
    def set_new_acme_account
      @acme_order = @acme_account.acme_orders.build(acme_order_params)
    end

    def set_acme_account
      @acme_account = AcmeAccount.find params[:acme_account_id]
    end

    def set_acme_order
      @acme_order = @acme_account.acme_orders.find(params[:id])
    end

    def acme_order_params
      params.fetch(:acme_order, {}).permit *acme_order_permit_params
    end

    def acme_order_permit_params
      [
        acme_authorizations_attributes: {},
        acme_identifiers_attributes: {}
      ]
    end

  end
end
