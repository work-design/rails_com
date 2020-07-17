module RailsCom::AcmeOrder
  extend ActiveSupport::Concern

  included do
    attribute :identifiers, :string, array: true
    attribute :file_name, :string
    attribute :file_content, :string
    attribute :record_name, :string
    attribute :record_content, :string

    belongs_to :acme_account
  end


  def http_challenge

  end

  def dns_challenge

  end

end
