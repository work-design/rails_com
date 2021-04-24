class Com::Admin::SmtpAccountsController < Com::Admin::BaseController
  before_action :set_smtp
  before_action :set_smtp_account, only: [:show, :edit, :update, :destroy]

  def index
    @smtp_accounts = SmtpAccount.page(params[:page])
  end

  def new
    @smtp_account = SmtpAccount.new
  end

  def create
    @smtp_account = SmtpAccount.new(smtp_account_params)

    unless @smtp_account.save
      render :new, locals: { model: @smtp_account }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @smtp_account.assign_attributes(smtp_account_params)

    unless @smtp_account.save
      render :edit, locals: { model: @smtp_account }, status: :unprocessable_entity
    end
  end

  def destroy
    @smtp_account.destroy
  end

  private
  def set_smtp
    @smtp = Smtp.find params[:smtp_id]
  end

  def set_smtp_account
    @smtp_account = SmtpAccount.find(params[:id])
  end

  def smtp_account_params
    params.fetch(:smtp_account, {}).permit(
      :user_name,
      :password
    )
  end

end
