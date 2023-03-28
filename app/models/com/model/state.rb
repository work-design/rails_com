module Com
  module Model::State
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :host, :string
      attribute :path, :string
      attribute :controller_path, :string
      attribute :action_name, :string
      attribute :request_method, :string
      attribute :referer, :string
      attribute :params, :json, default: {}
      attribute :body, :json, default: {}
      attribute :cookie, :json, default: {}
      attribute :session, :json, default: {}

      belongs_to :user, class_name: 'Auth::User', optional: true
      belongs_to :organ, class_name: 'Org::Organ', optional: true
    end

    def detail
      {
        host: host,
        controller: controller_path,
        action: action_name,
        **params.except('auth_token')
      }
    end

  end
end
