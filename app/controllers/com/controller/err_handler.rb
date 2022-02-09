module Com
  module Controller::ErrHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordInvalid, with: :record_not_save
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    end

    def record_not_save(exception)
      render 'err', locals: { target: exception.record, exception: exception, message: exception.message }, status: :unprocessable_entity
    end

    def record_not_found(exception)
      render 'err', locals: { exception: exception, message: exception.message }, status: :not_found
    end

  end
end
