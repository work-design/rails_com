module Com
  module Model::AcmeServicer
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :domain, :string
      attribute :key, :string, comment: '阿里云DNS'
      attribute :secret, :string

      encrypts :key, :secret
    end

    def client
      'Should implement in subclass'
    end

  end
end
