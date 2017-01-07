Rails.application.routes.draw do
  root 'buses#index'
  get 'buses/index'
  get 'schedule' => 'buses#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
