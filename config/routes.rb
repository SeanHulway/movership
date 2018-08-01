Rails.application.routes.draw do
  devise_for :users
  get 'home' => 'home#index'
  get 'contact' => 'contact#index'
  get 'info' => 'info#index'
  get 'quote' => 'quote#index'

  get 'home_funnel' => 'home_funnel#index'

  resources :estimates
  get 'build' => 'estimates#new'
  
  root 'home_funnel#index'
end
