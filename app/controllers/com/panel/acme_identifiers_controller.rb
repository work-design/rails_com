class Com::Panel::AcmeIdentifiersController < Com::Panel::BaseController
  before_action :set_acme_order, only: [:index, :new, :create]
  before_action :set_acme_identifier, only: [:show, :edit, :update, :destroy]

  def index
    @acme_identifiers = AcmeIdentifier.page(params[:page])
  end

  def new
    @acme_identifier = AcmeIdentifier.new
  end

  def create
    @acme_identifier = AcmeIdentifier.new(acme_identifier_params)

    unless @acme_identifier.save
      render :new, locals: { model: @acme_identifier }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @acme_identifier.assign_attributes(acme_identifier_params)

    unless @acme_identifier.save
      render :edit, locals: { model: @acme_identifier }, status: :unprocessable_entity
    end
  end

  def destroy
    @acme_identifier.destroy
  end

  private
  def set_acme_order
    @acme_order = AcmeOrder.find params[:acme_order_id]
  end

  def set_acme_identifier
    @acme_identifier = AcmeIdentifier.find(params[:id])
  end

  def acme_identifier_params
    params.fetch(:acme_identifier, {}).permit(
      :identifier
    )
  end

end
