Rails.application.routes.draw do
  
  resources :the_guards
  controller :common do
    get :locales
  end

end
