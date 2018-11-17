Rails.application.routes.draw do
  root 'posts#index'
  get 'posts/query_directory'
  get 'posts/query1'
  get 'posts/custom_search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

