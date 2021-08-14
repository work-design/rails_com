module Com
  module Model::MetaNamespace
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identifier, :string, default: '', null: false, index: true
      attribute :verify_organ, :boolean, default: false
      attribute :verify_member, :boolean, default: false
      attribute :verify_user, :boolean, default: false

      has_many :meta_controllers, foreign_key: :namespace_identifier, primary_key: :identifier
      has_many :meta_actions, foreign_key: :namespace_identifier, primary_key: :identifier

      validates :identifier, uniqueness: true
    end

    def name
      if super.present?
        super
      else
        identifier
      end
    end

    def id_by_business(business_identifier)
      "#{business_identifier}_#{identifier.blank? ? '_' : identifier}"
    end

    def role_path(business_identifier = nil)
      {
        business_identifier.to_s => role_hash(business_identifier)
      }
    end

    def role_hash(business_identifier = nil)
      meta_controllers = MetaController.includes(:meta_actions).where(business_identifier: business_identifier.presence, namespace_identifier: identifier.presence)
      {
        identifier.to_s => meta_controllers.each_with_object({}) { |i, h| h.merge! i.role_hash }
      }
    end

    class_methods do

      def sync
        existing = self.select(:identifier).distinct.pluck(:identifier)
        (RailsCom::Routes.namespaces.keys - existing).each do |namespace|
          n = self.find_or_initialize_by(identifier: namespace)
          n.save
        end

        (existing - RailsCom::Routes.namespaces.keys).each do |namespace|
          self.find_by(identifier: namespace).destroy
        end
      end

    end

  end
end
