Rails.application.routes.draw do
  root 'queries#index'
  get 'queries/dashboard'
  get 'queries/query_directory'
  get 'queries/complaint_rankings'
  get 'queries/custom_search'
  get 'queries/product_rankings'
  get 'queries/timeliness_rankings'
  get 'queries/dispute_rankings'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

