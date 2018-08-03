Rails.application.routes.draw do
  devise_for :users
  get 'home' => 'home#index'
  get 'contact' => 'contact#index'
  get 'info' => 'info#index'
  get 'quote' => 'quote#index'

  get 'home_funnel' => 'home_funnel#index'

  resources :estimates
  resources :builds

  resources :admin_hub do
    collection do
      get :toggle_admin
    end
  end
  
  root 'home_funnel#index'
end
