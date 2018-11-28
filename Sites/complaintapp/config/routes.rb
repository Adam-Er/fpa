Rails.application.routes.draw do
  get 'sessions/new'
  root 'queries#index'
  get 'queries/dashboard'
  get 'queries/query_directory'
  get 'queries/complaint_rankings'
  get 'queries/custom_search'
  get 'queries/product_rankings'
  get 'queries/timeliness_rankings'
  get 'queries/dispute_rankings'
  get 'queries/company_deep_dive'
  get 'queries/product_deep_dive'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

