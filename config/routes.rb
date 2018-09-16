Rails.application.routes.draw do

  scope :rails, as: 'rails', module: 'active_storage' do
    resources :attachments, only: [:destroy]
  end

  scope :rails, as: 'rails', module: 'active_storage_ext' do
    resources :videos, only: [:index, :show] do
      put :transfer, on: :member
    end
  end

end


RailsCom::Engine.routes.draw do

  scope :rails, as: 'rails', module: 'active_storage' do
    resources :attachments, only: [:destroy]
  end

end