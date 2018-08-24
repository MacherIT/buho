Rails.application.routes.draw do
  resources :reds
  devise_for :users

  # Solo para usuarios autenticados (todo el sitio)
  authenticated :user do
    resources :clientes
    root to: "clientes#index" # , as: :authenticated_root
    mount Sidekiq::Web => "/sidekiq" # monitoring console
  end

  # Si no esta autenicado
  root to: redirect("/users/sign_in")

  match "*unmatched", to: "errors#route_not_found", via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
