Rails.application.routes.draw do
  
  scope module: 'com' do
    controller :common do
      get :infos
      get :cache_list
      get :enum_list
      match :deploy, via: [:get, :post]
    end
  end

  scope 'rails/active_storage', module: :com do
    resources :direct_uploads, only: [:create]
  end

  scope :rails, module: 'com', as: 'rails_ext' do
    resources :videos, only: [:show] do
      put :transfer, on: :member
    end
    resources :audios, only: [:show] do
      put :transfer, on: :member
    end
    resources :pdfs, only: [:show] do
      member do
        get :png
        get :jpg
      end
    end
  end

  scope :admin, module: 'com/admin', as: :admin do
    resources :infos
    resources :cache_lists
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
