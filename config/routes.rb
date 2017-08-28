Rails.application.routes.draw do
  mount API::Root => '/api'

  resources :communities, format: false
  resources :communities, as: :my_communities,
            format: false,
            only: [:index]
  resources :communities, as: :hosting_communities,
            format: false,
            only: [:index]
  resources :communities, as: :following_communities,
            format: false,
            only: [:index]
end
