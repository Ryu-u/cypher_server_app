Rails.application.routes.draw do
  mount API::Root => '/api'

  resources :communities,
            format: false,
            except: [:index]
  get '/my_communities' =>
          'communities#my_communities', format: false
  get '/hosting_communities' =>
      'communities#hosting_communities',
      format: false
  get '/following_communities' =>
      'communities#following_communities',
      format: false
end
