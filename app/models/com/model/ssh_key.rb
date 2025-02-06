# frozen_string_literal: true
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

  end
end