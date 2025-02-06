require 'sshkey'
module Com
  module Model::SshKey
    extend ActiveSupport::Concern

    included do
      attribute :host, :string
      attribute :domain, :string
      attribute :private_key, :string
      attribute :public_key, :string
      attribute :fingerprint, :string

      encrypts :private_key

      belongs_to :user, class_name: 'Auth::User', optional: true

      before_validation :generate_key_pair, on: :create
      before_save :calculate_fingerprint, if: -> { private_key_changed? }

      validates :host, presence: true
      validates :private_key, presence: true
      validates :public_key, presence: true
    end

    def generate_key_pair
      ssh_key = SSHKey.generate
      self.private_key = ssh_key.private_key
      self.public_key = ssh_key.ssh_public_key
    end

    def calculate_fingerprint
      self.fingerprint = SSHKey.fingerprint(public_key)
    end

    def deploy
      ENV['SERVER'] = host
      ENV['PRIVATE_KEY'] = private_key
      cli = Kamal::Cli::Main.new('-c')
      cli.deploy
    end

  end
end