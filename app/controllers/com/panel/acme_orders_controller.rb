module Com
  class Panel::AcmeOrdersController < Panel::BaseController
    before_action :set_acme_account
    before_action :set_acme_order, only: [:show, :edit, :order, :verify, :cert, :update, :destroy]

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

    def create
      @acme_order = @acme_account.acme_orders.build(acme_order_params)

      unless @acme_order.save
        render :new, locals: { model: @acme_order }, status: :unprocessable_entity
      end
    end

    def order
      r = @acme_order.order(true)
      if r.respond_to?(:status) && ['pending'].include?(r.status)
        @acme_order.authorizations
      end

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
    def set_acme_account
      @acme_account = AcmeAccount.find params[:acme_account_id]
    end

    def set_acme_order
      @acme_order = @acme_account.acme_orders.find(params[:id])
    end

    def acme_order_params
      [
        acme_authorizations_attributes: {},
        acme_identifiers_attributes: {}
      ]
    end

  end
end
