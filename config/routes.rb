Rails.application.routes.draw do
  # For details on the DSL available within this file, see
  # https://guides.rubyonrails.org/routing.html
  
  resources :nodes do
    collection do
      get :common_ancestor
      get :birds
    end
  end
end
