Rails.application.routes.draw do
  root 'buses#index'
  get 'main' => 'buses#index'
  get 'schedule' => 'buses#show'
  get 'temp' => 'buses#temp'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
