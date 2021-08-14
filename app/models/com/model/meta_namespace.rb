module Com
  module Model::MetaNamespace
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identifier, :string
      attribute :verify_organ, :boolean, default: false
      attribute :verify_member, :boolean, default: false
      attribute :verify_user, :boolean, default: false

      has_many :meta_controllers, foreign_key: :namespace_identifier, primary_key: :identifier

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

    def role_hash(business_identifier)
      MetaAction.where(business_identifier: business_identifier, namespace_identifier: identifier)
      .select(:controller_path, :action_name, :id)
      .group_by(&:controller_path).transform_values! do |v|
        v.each_with_object({}) { |i, h| h.merge! i.action_name => i.id }
      end
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
