module JiaBo
  class Panel::DeviceOrgansController < Panel::BaseController
    before_action :set_app
    before_action :set_device, only: [:show, :edit, :update, :destroy, :test]
    before_action :set_new_device, only: [:new, :create]

    def sync
      @app.sync_devices
    end

    def test
      @device.test
    end

    private
    def set_device
      @device = @app.devices.find params[:id]
    end

    def set_new_device
      @device = @app.devices.build device_params
    end

    def set_app
      @app = App.find params[:app_id]
    end

    def device_params
      params.fetch(:device_organ, {}).permit(
        :device_id,
        :organ_id,
        :default
      )
    end

  end
end
