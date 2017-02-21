Rails.application.routes.draw do
  root 'buses#index'
  get 'main' => 'buses#index'
  get 'buses/index2'
  get 'schedule' => 'buses#show'
  get 'info' => 'buses#info'
  get 'estimations/index'
  get 'index' => 'buses#test'
  get 'set_stations' => 'buses#set_stations'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
