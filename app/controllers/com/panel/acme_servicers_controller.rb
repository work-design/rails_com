module Com
  class Panel::AcmeServicersController < Panel::BaseController
    before_action :set_new_acme_servicer, only: [:new, :create]

    private
    def set_new_acme_servicer
      @acme_servicer = AcmeServicer.new(acme_servicer_params)
    end

    def acme_servicer_params
      params.fetch(:acme_servicer, {}).permit(
        :type,
        :key,
        :secret,
        acme_domains: []
      )
    end

  end
end
