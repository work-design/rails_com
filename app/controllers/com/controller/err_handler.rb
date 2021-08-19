module Com
  module Controller::ErrHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordInvalid, with: :record_not_save
    end

    def record_not_save(exception)
      render 'err', locals: { target: exception.record }, status: :unprocessable_entity
    end
  end
end
