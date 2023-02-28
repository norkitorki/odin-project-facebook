Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home', as: :home
  get 'discover', to: 'static_pages#discover'
  get 'tag', to: 'tags#show'
  delete 'notifications', to: 'notifications#clear'

  resources :friend_requests, except: %i[ edit update ]
  resources :posts, except: :index
  resources :comments, except: :index
  resources :likes, only: %i[ create destroy ]
  resources :tags, only: :index
  resources :notifications, only: %i[ index show destroy ]
  resources :friendships, only: :destroy
  resources :shares, except: %i[ edit update ]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    resources :users, only: :show do
      member do
        get 'activity'
        get 'posts'
        get 'comments'
        get 'friends'
      end
    end
  end

  # Omniauth callback route
  get 'auth/facebook/callback', to: 'users/sessions#create'
end
