module Com
  module Model::MetaAction
    extend ActiveSupport::Concern

    included do
      attribute :namespace_identifier, :string, default: '', null: false, index: true
      attribute :business_identifier, :string, default: '', null: false, index: true
      attribute :controller_path, :string, null: false, index: true
      attribute :controller_name, :string, null: false
      attribute :action_name, :string
      attribute :path, :string
      attribute :verb, :string
      attribute :required_parts, :string, array: true
      attribute :position, :integer
      attribute :landmark, :boolean

      belongs_to :meta_business, foreign_key: :business_identifier, primary_key: :identifier
      belongs_to :meta_namespace, foreign_key: :namespace_identifier, primary_key: :identifier
      belongs_to :meta_controller, foreign_key: :controller_path, primary_key: :controller_path

      enum operation: {
        list: 'list',
        read: 'read',
        add: 'add',
        edit: 'edit',
        remove: 'remove'
      }, _default: 'read'

      default_scope -> { order(position: :asc, id: :asc) }

      acts_as_list scope: [:business_identifier, :namespace_identifier, :controller_path]

      before_validation :sync_from_controller, if: -> { meta_controller && (controller_path_changed? || meta_controller.new_record?) }
    end

    def role_path
      {
        business_identifier.to_s => {
          namespace_identifier.to_s => {
            controller_path => role_hash
          }
        }
      }
    end

    def role_hash
      { action_name => id }
    end

    def identifier
      [business_identifier, namespace_identifier, controller_path, (action_name.blank? ? '_' : action_name)].join('_')
    end

    def name
      t1 = I18n.t "#{[business_identifier, namespace_identifier, controller_name, action_name].join('.')}.title", default: nil
      return t1 if t1

      t2 = self.class.enum_i18n :action_name, self.action_name
      return t2 if t2

      identifier
    end

    def sync_from_controller
      self.business_identifier = meta_controller.business_identifier
      self.namespace_identifier = meta_controller.namespace_identifier
    end

  end
end
