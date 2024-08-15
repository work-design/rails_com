# frozen_string_literal: true

namespace :job, defaults: { business: 'job' } do
  namespace :panel, defaults: { namespace: 'panel' } do
    root 'home#index'
    resources :executions, only: [:index, :show, :destroy] do
      member do
        patch :perform
      end
    end
    resources :queues, only: [:index] do
      member do
        post :pause
        post :resume
      end
      resources :jobs, only: [:index, :show, :destroy] do
        collection do
          get :failed
          get :scheduled
          get :blocked
          get :running
          get :ready
          get :clearable
          delete :clear_all
        end
        member do
          put :discard
          put :reschedule
          put :retry
          patch :perform
        end
      end
    end
    resources :cron_entries, only: [:index, :show] do
      member do
        post :enqueue
      end
    end
  end
end
