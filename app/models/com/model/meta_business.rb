module Com
  module Model::MetaBusiness
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identifier, :string, default: '', null: false, index: true
      attribute :position, :integer
      attribute :synced_at, :datetime

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
      MetaNamespace.where(identifier: meta_controllers.select(:namespace_identifier).distinct.pluck(:namespace_identifier))
    end

    def role_path
      {
        identifier => role_hash
      }
    end

    def role_hash
      meta_namespaces.each_with_object({}) { |i, h| h.merge! i.identifier => i.role_hash(identifier) }
    end

    def namespaces
      RailsCom::Routes.actions
    end

    def sync_all(now: Time.current)
      if RailsCom::Routes.actions.key? identifier
        sync(now: now)
      else
        self.update synced_at: now
        self.prune
        self.destroy
      end
    end

    def sync(now: Time.current)
      RailsCom::Routes.actions[identifier].each do |namespace, controllers|
        controllers.each do |controller, actions|
          meta_controller = meta_controllers.find { |i| i.controller_path == controller } || meta_controllers.build(controller_path: controller)
          meta_controller.namespace_identifier = namespace
          meta_controller.controller_name = controller.to_s.split('/')[-1]
          meta_controller.synced_at = now
          meta_controller.save!

          actions.each do |action_name, action|
            meta_action = meta_controller.meta_actions.find { |i| i.action_name == action_name } || meta_controller.meta_actions.build(action_name: action_name)
            meta_action.controller_name = meta_controller.controller_name
            meta_action.path = action[:path]
            meta_action.verb = action[:verb]
            meta_action.required_parts = action[:required_parts]
            meta_action.synced_at = now
            meta_action.save!
          end
        end
      end
      self.update! synced_at: now
      prune
    end

    def prune
      meta_controllers.where.not(synced_at: synced_at).or(meta_controllers.where(synced_at: nil)).delete_all
      meta_actions.where.not(synced_at: synced_at).or(meta_actions.where(synced_at: nil)).delete_all
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
