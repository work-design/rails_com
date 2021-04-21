module Com
  module Model::Smtp
    extend ActiveSupport::Concern

    included do
      attribute :address, :string
      attribute :port, :string
      attribute :user_name, :string
      attribute :password, :string
      attribute :enable_starttls_auto, :boolean, default: true
      attribute :openssl_verify_mode, :boolean, 

      enum authentication: {
        plain: 'plain',
        login: 'login',
        cram_md5: 'cram_md5'
      }


    end



  end
end
