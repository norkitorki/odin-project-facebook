Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home', as: :home
  get 'discover', to: 'static_pages#discover'
  
  resources :friend_requests, except: %i[ edit update ]
  resources :posts, except: :index
  resources :comments, except: %i[ index show ]
  resources :likes, only: %i[ create destroy ]
  resources :notifications, only: %i[ index show ] do
    delete '/', to: 'notifications#destroy', on: :collection
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    resources :users, only: :show
  end
end
