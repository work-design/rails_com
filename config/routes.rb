Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    namespace :job, defaults: { business: 'job' } do
      namespace :panel, defaults: { namespace: 'panel' } do
        root to: 'jobs#index'
        resources :processes, only: [:index]
        resources :executions, only: [:index, :show, :destroy] do
          member do
            patch :perform
          end
        end
        resources :jobs, only: [:index, :show, :destroy] do
          collection do
            get :scheduled
            get :running
            get :discarded
          end
          member do
            put :discard
            put :reschedule
            put :retry
            patch :perform
          end
        end
        resources :cron_entries, only: [:index, :show] do
          member do
            post :enqueue
          end
        end
      end
    end

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
        post :actions
        match :deploy, via: [:get, :post]
        get 'assets/*path' => :asset, constraints: ->(req) { [:jpeg, :png, :webp].include? req.format.symbol }
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
        root 'home#index'
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
            post :sync
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
          resources :devices do
            collection do
              post :sync
            end
            member do
              patch :test
            end
          end
          resources :templates do
            collection do
              post :sync
            end
          end
        end
      end
    end

    namespace :roled, defaults: { business: 'roled' } do
      namespace :panel, defaults: { namespace: 'panel' } do
        resources :roles do
          member do
            post :overview
            post :namespaces
            post :controllers
            patch :business_on
            patch :business_off
            patch :namespace_on
            patch :namespace_off
            patch :controller_on
            patch :controller_off
            patch :action_on
            patch :action_off
          end
          resources :who_roles, only: [:index, :new, :create, :destroy]
          resources :role_rules, except: [:destroy] do
            collection do
              post :disable
              delete '' => :destroy
            end
          end
        end
        scope path: ':who_type/:who_id' do
          resource :whos, only: [:show, :edit, :update]
        end
      end

      namespace :admin, defaults: { namespace: 'admin' } do
        scope path: ':who_type/:who_id' do
          resource :who_roles, only: [:show, :edit, :update]
        end
      end
    end
  end
end

Rails.application.routes.append do
  match '*path' => 'com/log#not_found', via: :all
end if RailsCom.config.intercept_not_found
