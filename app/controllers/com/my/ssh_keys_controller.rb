module Com
  class My::SshKeysController < My::BaseController
    before_action :set_ssh_key, only: [:show, :edit, :update, :destroy, :deploy]
    before_action :set_new_ssh_key, only: [:new, :create]

    def index
      @ssh_keys = SshKey.where(user_id: current_user.id).page(params[:page])
    end

    def deploy

    end

    private
    def set_ssh_key
      @ssh_key = SshKey.where(user_id: current_user.id).find params[:id]
    end

    def set_new_ssh_key
      @ssh_key = SshKey.new(ssh_key_params)
    end

    def ssh_key_params
      p = params.fetch(:ssh_key, {}).permit(
        :host,
        :domain
      )
      p.merge! user_id: current_user.id
    end

  end
end
