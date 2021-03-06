Rails.application.routes.draw do
  resources :posts
  devise_for :users

  # Solo para usuarios autenticados (todo el sitio)


  authenticated :user do
    get 'calendario/index'
    get "/clientes/:cliente_id/redes/:red_id/posts", to: "posts#by_red"
    get "/posts", to: "posts#index"
    # get "/posts.json", to: "posts#index_json"
    resources :clientes do
      resources :redes do
        resources :posts
      end
    end
    resources :redes
    post '/posts/create/ig', to: 'posts#create_ig'
    put '/posts/:id/edit/ig', to: 'posts#update_ig'
    delete '/posts/:id/delete/ig', to: 'posts#destroy_ig'
    post "/post_test/:id", to: "posts#post_test"
    post "/post_imagen/:id", to: "posts#imagen_url"
    root to: "clientes#index" # , as: :authenticated_root
    # mount Sidekiq::Web => "/sidekiq" # monitoring console
  end

  # Si no esta autenicado
  root to: redirect("/users/sign_in")

  # Saco esta regla porque trae conflictos con los URL de blobs de Active Storage
  # match "*unmatched", to: "errors#route_not_found", via: :all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
