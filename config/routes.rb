Rails.application.routes.draw do
  root 'buses#index'
  resources :buses
  get 'main' => 'buses#index'
  get 'overlap' => 'buses#index_overlap'
  get 'schedule' => 'buses#show'
  get 'estimations/index'
  get '/modal' => 'buses#modal'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
