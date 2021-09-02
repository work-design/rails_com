module Com
  class Panel::InfosController < Panel::BaseController

    private
    def info_permit_params
      [
        :code,
        :value,
        :version,
        :platform
      ]
    end

  end
end
