module Com
  class Panel::InboundEmailsController < Panel::BaseController
    before_action :set_inbound_email, only: [:show, :edit, :update, :destroy]

    def index
      @inbound_emails = ActionMailbox::InboundEmail.page(params[:page])
    end

    def new
      @inbound_email = ActionMailbox::InboundEmail.new
    end

    def create
      @inbound_email = ActionMailbox::InboundEmail.new(inbound_email_params)

      unless @inbound_email.save
        render :new, locals: { model: @inbound_email }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @inbound_email.assign_attributes(inbound_email_params)

      unless @inbound_email.save
        render :edit, locals: { model: @inbound_email }, status: :unprocessable_entity
      end
    end

    def destroy
      @inbound_email.destroy
    end

    private
    def set_inbound_email
      @inbound_email = ActionMailbox::InboundEmail.find(params[:id])
    end

    def inbound_email_params
      params.fetch(:inbound_email, {}).permit(
      )
    end

  end
end
