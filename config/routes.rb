Rails.application.routes.draw do

  scope 'rails/active_storage', module: :active_storage_ext do
    resources :direct_uploads, only: [:create]
  end

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

  scope :admin, module: 'com/admin', as: :admin do
    resources :infos
    resources :cache_lists
  end

  scope module: 'com' do
    controller :common do
      get :infos
      get :cache_list
      get :enum_list
      get :deploy
    end
  end

end
