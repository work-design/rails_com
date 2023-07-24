module Com
  module Controller::ErrHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordInvalid, with: :record_not_save
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from Com::DisposableTokenError, with: :disposable_auth_fail
      rescue_from Roled::DeniedError, with: :role_denied
    end

    def record_not_save(exception)
      render 'err', layout: 'raw', locals: { target: exception.record, exception: exception, message: exception.message }, status: :unprocessable_entity
    end

    def record_not_found(exception)
      render 'err_not_found', layout: 'raw', locals: { exception: exception, message: exception.message }, status: :not_found
    end

    def disposable_auth_fail(exception)
      render 'disposable_auth_fail', layout: 'raw'
    end

    def role_denied(exception)
      render 'role_denied', layout: 'raw', status: 403
    end

  end
end
