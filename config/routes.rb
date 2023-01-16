Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home', as: :home
  get 'discover', to: 'static_pages#discover'
  get 'tag', to: 'tags#show'
  
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
    resources :users, only: :show do
      member do
        get 'posts'
        get 'comments'
        get 'friends'
      end
    end
  end

  # Omniauth callback route
  get 'auth/facebook/callback', to: 'users/sessions#create'
end
