Rails.application.routes.draw do
  get 'home' => 'home#index'
  get 'contact' => 'contact#index'
  get 'info' => 'info#index'
  get 'quote' => 'quote#index'

  get 'home_funnel' => 'home_funnel#index'
  
  root 'home_funnel#index'
end
