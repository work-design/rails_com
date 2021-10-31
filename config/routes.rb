Rails.application.routes.draw do

  scope 'rails/active_storage', module: :com, defaults: { business: 'com' } do
    resources :direct_uploads, only: [:create]
  end

  controller :home do
    get :index
  end

  namespace :panel, defaults: { namespace: 'panel' } do
    controller :home do
      get :index
    end
  end

  scope :rails, module: 'com', as: :rails_ext, defaults: { business: 'com' } do
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

  scope module: 'com', defaults: { business: 'com' } do
    controller :common do
      get :infos
      get :cache_list
      get :enum_list
      get :qrcode
      get :test_raise
      get :cancel
      match :deploy, via: [:get, :post]
    end
    controller :log do
      get '/not_founds' => :index
      post '/csp_violation_report' => :csp
    end
    resources :nodes, only: [] do
      collection do
        get :children
        get :outer
        get :outer_search
      end
    end
  end

  namespace :com, defaults: { business: 'com' } do
    namespace :panel, defaults: { namespace: 'panel' } do
      resources :errs, only: [:index, :show, :destroy]
      resources :csps, only: [:index, :show, :destroy]
      resources :meta_namespaces do
        collection do
          post :sync
        end
        member do
          patch :move_lower
          patch :move_higher
        end
      end
      resources :meta_businesses do
        collection do
          post :sync
        end
        member do
          patch :move_lower
          patch :move_higher
        end
      end
      resources :meta_controllers, only: [:index] do
        collection do
          post :sync
          post :meta_namespaces
          post :meta_controllers
          post :meta_actions
        end
        member do
          patch :move_lower
          patch :move_higher
        end
        resources :meta_actions do
          member do
            patch :move_lower
            patch :move_higher
            get :roles
          end
        end
      end
      resources :meta_models do
        collection do
          post :sync
        end
        resources :meta_columns do
          member do
            patch :sync
            patch :test
          end
        end
      end
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
        resources :acme_orders, only: [] do
          resources :acme_identifiers, only: [:index, :new, :create]
          resources :acme_identifiers, only: [:show, :edit, :update, :destroy]
        end
      end
    end
  end

  namespace :jia_bo, defaults: { business: 'jia_bo' } do
    namespace :panel, defaults: { namespace: 'panel' } do
      resources :apps do
        resources :devices
        resources :templates
      end
    end
  end

end

Rails.application.routes.append do
  match '*path' => 'com/log#not_found', via: :all
end if RailsCom.config.intercept_not_found
