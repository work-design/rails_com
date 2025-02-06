module Com
  class My::SshKeysController < My::BaseController

    private
    def set_new_ssh_key
      params.fetch(:ssh_key, {}).permit(
        :host,
        :domain
      )
    end

  end
end
