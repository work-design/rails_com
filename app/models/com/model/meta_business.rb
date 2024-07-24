module Com
  module Model::MetaBusiness
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identifier, :string, default: '', null: false, index: true
      attribute :position, :integer

      has_many :meta_controllers, foreign_key: :business_identifier, primary_key: :identifier
      has_many :meta_actions, foreign_key: :business_identifier, primary_key: :identifier

      has_one_attached :logo

      validates :identifier, uniqueness: true

      positioned
    end

    def name
      return super if super.present?

      t = I18n.t "#{identifier}.title", default: nil
      return t if t

      identifier
    end

    def tr_id
      "tr_#{identifier.blank? ? '_' : identifier}"
    end

    def meta_namespaces
      MetaNamespace.where(identifier: MetaController.unscope(:order).select(:namespace_identifier).where(business_identifier: identifier).distinct.pluck(:namespace_identifier)).order(id: :asc)
    end

    def role_path
      {
        identifier => role_hash
      }
    end

    def role_hash
      meta_namespaces.each_with_object({}) { |i, h| h.merge! i.identifier => i.role_hash(identifier) }
    end

    class_methods do

      def sync
        existing = self.select(:identifier).distinct.pluck(:identifier)
        business_keys = RailsCom::Routes.businesses.keys

        (business_keys - existing).each do |business|
          b = self.find_or_initialize_by(identifier: business)
          b.save
        end

        (existing - business_keys).each do |business|
          self.find_by(identifier: business).destroy
        end
      end

    end

  end
end
