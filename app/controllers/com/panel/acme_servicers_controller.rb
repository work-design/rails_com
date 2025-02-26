module Com
  class Panel::AcmeServicersController < Panel::BaseController

    private
    def acme_servicer_permit_params
      [
        :key,
        :secret
      ]
    end

  end
end
