class Com::Panel::AcmeOrdersController < Com::Panel::BaseController
  before_action :set_acme_account
  before_action :set_acme_order, only: [:show, :edit, :order, :update, :destroy]

  def index
    q_params = {
      acme_account_id: @acme_account.id
    }
    q_params.merge! params.permit(:acme_account_id)

    @acme_orders = AcmeOrder.default_where(q_params).page(params[:page])
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

  def add_item
    @acme_order = @acme_account.acme_orders.build
    @acme_order.acme_identifiers.build
  end

  def remove_item
  end

  def order
    @acme_order.order
    render 'update'
  end

  def show
  end

  def edit
  end

  def update
    @acme_order.assign_attributes(acme_order_params)

    unless @acme_order.save
      render :edit, locals: { model: @acme_order }, status: :unprocessable_entity
    end
  end

  def destroy
    @acme_order.destroy
  end

  private
  def set_acme_account
    @acme_account = AcmeAccount.find params[:acme_account_id]
  end

  def set_acme_order
    @acme_order = @acme_account.acme_orders.find(params[:id])
  end

  def acme_order_params
    params.fetch(:acme_order, {}).permit(
      acme_authorizations_attributes: {},
      acme_identifiers_attributes: {}
    )
  end

end
