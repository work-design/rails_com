module JiaBo
  class Admin::DevicesController < Admin::BaseController
    before_action :set_app, only: [:scan]
    before_action :set_device, only: [:show, :edit, :update, :destroy, :actions, :test]
    before_action :set_new_device, only: [:new, :create]

    def index
      @devices = current_organ.devices
      @apps = JiaBo::App.where.not(id: @devices.pluck(:app_id))
    end

    def scan
      @device = @app.devices.find_or_initialize_by(device_id: params[:result])
      @device.device_organs.find_or_initialize_by(organ_id: current_organ.id)
      @device.save
    end

    def test
      @device.test
    end

    private
    def set_device
      @device = @app.devices.find params[:id]
    end

    def set_app
      @app = App.find params[:app_id]
    end

    def device_params
      params.fetch(:device, {}).permit(
        :device_id,
        :dev_name,
        :grp_id
      )
    end

  end
end
