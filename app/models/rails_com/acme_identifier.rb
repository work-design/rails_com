module RailsCom::AcmeIdentifier
  extend ActiveSupport::Concern

  included do
    attribute :identifier, :string
    attribute :file_name, :string
    attribute :file_content, :string
    attribute :record_name, :string
    attribute :record_content, :string
    attribute :domain, :string

    belongs_to :acme_order
  end



end
