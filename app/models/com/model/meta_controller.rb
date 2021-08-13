module Com
  module Model::MetaController
    extend ActiveSupport::Concern

    included do
      attribute :namespace_identifier, :string, index: true
      attribute :business_identifier, :string, index: true
      attribute :controller_path, :string
      attribute :controller_name, :string
      attribute :position, :integer

      belongs_to :meta_namespace, foreign_key: :namespace_identifier, primary_key: :identifier, optional: true
      belongs_to :meta_business, foreign_key: :business_identifier, primary_key: :identifier, optional: true

      has_many :meta_actions, ->(o) { where(business_identifier: o.business_identifier, namespace_identifier: o.namespace_identifier).order(position: :asc) }, foreign_key: :controller_path, primary_key: :controller_path, dependent: :destroy, inverse_of: :meta_controller
      accepts_nested_attributes_for :meta_actions, allow_destroy: true

      default_scope -> { order(position: :asc, id: :asc) }

      validates :controller_path, uniqueness: { scope: [:business_identifier, :namespace_identifier] }

      acts_as_list scope: [:namespace_identifier, :business_identifier]
    end

    def identifier
      [business_identifier, namespace_identifier, (controller_path.blank? ? '_' : controller_path)].join('_')
    end

    def business_name
      t = I18n.t "#{business_identifier}.title", default: nil
      return t if t

      business_identifier
    end

    def namespace_name
      t = I18n.t "#{business_identifier}.#{namespace_identifier}.title", default: nil
      return t if t

      namespace_identifier
    end

    def name
      t = I18n.t "#{controller_path.to_s.split('/').join('.')}.index.title", default: nil
      return t if t

      controller_path
    end

    def role_hash
      meta_actions.each_with_object({}) { |i, h| h.merge! i.action_name => i.id }
    end

    class_methods do

      def actions
        result = {}
        MetaBusiness.all.includes(meta_controllers: :meta_actions).each do |meta_business|
          result.merge! meta_business.identifier => meta_business.meta_controllers.group_by(&:namespace_identifier).transform_values!(&->(meta_controllers){
            meta_controllers.each_with_object({}) { |meta_controller, h| h.merge! meta_controller.controller_name => meta_controller.meta_actions.pluck(:action_name) }
          })
        end
        result
      end

      def sync
        RailsCom::Routes.actions.each do |business, namespaces|
          namespaces.each do |namespace, controllers|
            controllers.each do |controller, actions|
              meta_controller = MetaController.find_or_initialize_by(business_identifier: business, namespace_identifier: namespace, controller_path: controller)
              meta_controller.controller_name = controller.to_s.split('/')[-1]

              actions.each do |action_name, action|
                meta_action = meta_controller.meta_actions.find_or_initialize_by(action_name: action_name)
                meta_action.controller_name = meta_controller.controller_name
                meta_action.path = action[:path]
                meta_action.verb = action[:verb]
                meta_action.required_parts = action[:required_parts]
              end

              present_meta_actions = meta_controller.meta_actions.pluck(:action_name)
              meta_controller.meta_actions.select(&->(i){ (present_meta_actions - actions.keys).include?(i.action_name) }).each do |meta_action|
                meta_action.mark_for_destruction
              end

              meta_controller.save if meta_controller.meta_actions.length > 0
            end

            present_controllers = MetaController.where(business_identifier: business, namespace_identifier: namespace).pluck(:controller_path)
            MetaController.where(business_identifier: business, namespace_identifier: namespace, controller_path: (present_controllers - controllers.keys)).each do |meta_controller|
              meta_controller.destroy
            end
          end
        end
      end

    end

  end
end
