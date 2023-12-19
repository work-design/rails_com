# frozen_string_literal: true

namespace :job, defaults: { business: 'job' } do
  namespace :panel, defaults: { namespace: 'panel' } do
    root 'home#index'
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
