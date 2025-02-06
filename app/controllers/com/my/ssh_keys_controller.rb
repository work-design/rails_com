module Com
  class My::SshKeysController < My::BaseController
    before_action :set_new_ssh_key, only: [:new, :create]

    def index
      @ssh_keys = SshKey.where(user_id: current_user.id)
    end

    private
    def set_new_ssh_key
      params.fetch(:ssh_key, {}).permit(
        :host,
        :domain
      )
    end

  end
end
