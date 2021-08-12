module Com
  module Model::MetaModel
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :record_name, :string, index: true
      attribute :description, :string

      has_many :meta_models, foreign_key: :record_name, primary_key: :record_name
    end

  end
end
