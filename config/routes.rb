Rails.application.routes.draw do

  scope :rails, module: 'active_storage_ext', as: 'rails_ext' do
    resources :videos, only: [:show] do
      put :transfer, on: :member
    end
    resources :audios, only: [:show] do
      put :transfer, on: :member
    end
  end

  scope :rails, module: 'active_storage_ext/admin', as: 'rails_ext' do
    resources :attachments, only: [:index, :destroy] do
      get :garbled, on: :collection
      delete :delete, on: :member
    end
    resources :blobs, only: [:index, :new, :create, :destroy] do
      get :unattached, on: :collection
    end
    resources :blob_defaults
  end

end
