Rails.application.routes.draw do
  root to: 'visitors#index'
  get '/bikes/unverfied' => 'bikes#unverified'
  get '/bikes/image/:id' => 'bikes#image'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'

  resources :bikes, only: [ :show, :new, :create, :edit, :update, :destroy ]
  resources :users, only: [ :show, :new, :create, :edit, :update, :destroy ]
  
end
