Rails.application.routes.draw do

  scope :rails, as: 'rails', module: 'active_storage' do
    resources :attachments, only: [:destroy]
  end

  scope :rails, as: 'rails', module: 'active_storage_ext' do
    resources :videos, only: [:index, :show]
  end

end
