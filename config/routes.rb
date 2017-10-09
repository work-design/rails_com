Rails.application.routes.draw do
  
  resources :the_guards
  controller :common do
    get :locales
  end

end

Rails.application.routes.append do
  match '*path' => 'common#not_found', via: :all
end
