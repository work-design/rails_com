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
      attribute :destroyable, :boolean, default: true

      belongs_to :user, class_name: 'Auth::User', optional: true
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      after_find :destroy_after_used, if: -> { destroyable? }
    end

    def detail
      {
        host: host,
        controller: controller_path,
        action: action_name,
        **params.except('auth_token')
      }
    end

    def url
      if request_method == 'GET'
        Rails.application.routes.url_for(
          controller: controller_path,
          action: action_name,
          **params
        )
      elsif referer.present?
        referer
      else
        organ.redirect_url
      end
    end

    def destroy_after_used
      StateDestroyJob.perform_later(self.id)
    end

  end
end
