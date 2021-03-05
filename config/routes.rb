Rails.application.routes.draw do

  scope module: 'com', defaults: { namespace: 'application', business: 'com' } do
    controller :common do
      get :infos
      get :cache_list
      get :enum_list
      get :qrcode
      get :test_raise
      get :cancel
      match :deploy, via: [:get, :post]
    end
    resources :nodes, only: [] do
      collection do
        get :children
        get :outer
        get :outer_search
      end
    end
  end

  scope 'rails/active_storage', module: :com, defaults: { namespace: 'application', business: 'com' } do
    resources :direct_uploads, only: [:create]
  end

  scope :rails, module: 'com', as: :rails_ext, defaults: { namespace: 'application', business: 'com' } do
    resources :videos, only: [:show] do
      member do
        put :transfer
      end
    end
    resources :audios, only: [:show] do
      member do
        put :transfer
      end
    end
    resources :pdfs, only: [:show] do
      member do
        get :png
        get :jpg
      end
    end
  end

  scope :panel, module: 'com/panel', as: :panel, defaults: { namespace: 'panel', business: 'com' } do
    resources :infos
    resources :cache_lists
    resources :inbound_emails
    resources :attachments, only: [:index, :destroy] do
      collection do
        get :garbled
      end
      member do
        delete :delete
      end
    end
    resources :blobs, only: [:index, :show, :new, :create, :destroy] do
      collection do
        get :unattached
      end
    end
    resources :blob_defaults do
      collection do
        get :add
      end
    end
    resources :acme_accounts do
      resources :acme_orders do
        member do
          patch :order
          patch :verify
          patch :cert
        end
      end
      resources :acme_orders, shallow: true, only: [] do
        resources :acme_identifiers, only: [:index, :new, :create]
        resources :acme_identifiers, only: [:show, :edit, :update, :destroy]
      end
    end
  end

end
