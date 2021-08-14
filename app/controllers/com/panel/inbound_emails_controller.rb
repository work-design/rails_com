module Com
  class Panel::InboundEmailsController < Panel::BaseController
    before_action :set_inbound_email, only: [:show, :destroy]

    def index
      @inbound_emails = ActionMailbox::InboundEmail.page(params[:page])
    end

    private
    def set_inbound_email
      @inbound_email = ActionMailbox::InboundEmail.find(params[:id])
    end

  end
end
