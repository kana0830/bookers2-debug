Rails.application.routes.draw do
  get 'search/search'
  devise_for :users
  resources :users, only: [:show,:index,:edit,:update]
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resource :book_comments, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy] do
    member do
      get :followings, :followers
    end 
  end
  root 'home#top'
  get 'home/about'
  get '/search' => 'search#search'
end