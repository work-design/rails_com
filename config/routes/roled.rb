# frozen_string_literal: true

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
      resources :tabs do
        member do
          patch :move_lower
          patch :move_higher
          patch :reorder
        end
      end
    end
    scope path: ':who_type/:who_id' do
      resource :whos, only: [:show, :edit, :update]
    end
  end

  namespace :admin, defaults: { namespace: 'admin' } do
    scope path: ':who_type/:who_id' do
      resource :whos, only: [:show, :edit, :update]
      resource :who_roles, only: [:show, :edit, :update]
    end
  end
end
