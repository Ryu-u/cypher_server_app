Rails.application.routes.draw do
  get 'sessions/new'

  mount API::Root => '/api'

  get '/auth/twitter/callback' => 'twitter#callback'

  get '/login' => 'sessions#login', format: false
  post '/login' => 'sessions#create', format: false
  delete '/logout' => 'sessions#logout', format: false

  resources :users,
            format: false,
            except: [:index]

  resources :communities,
            format: false,
            except: [:index]

  resources :cyphers,
            format: false

  get '/my_communities' =>
          'communities#my_communities', format: false
  get '/hosting_communities' =>
      'communities#hosting_communities',
      format: false
  get '/following_communities' =>
      'communities#following_communities',
      format: false

  get '/my_cyphers' =>
          'cyphers#my_cyphers',
      format: false
  get '/hosting_cyphers' =>
          'cyphers#hosting_cyphers',
      format: false
end
