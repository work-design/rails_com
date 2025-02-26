module Com
  module Model::AcmeDns
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :domain, :string
      attribute :key, :string, comment: '阿里云DNS'
      attribute :secret, :string

      encrypts :key, :secret
    end

    def client
      return @dns if defined? @dns
      @dns = AliDns.new(key, secret)
    end

  end
end
