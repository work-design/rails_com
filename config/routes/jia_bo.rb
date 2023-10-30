# frozen_string_literal: true

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
        resources :device_organs
      end
    end
  end
  namespace :admin, defaults: { namespace: 'admin' } do
    resources :device_organs do
      collection do
        post :scan
      end
    end
  end
end
