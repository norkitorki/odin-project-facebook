Rails.application.routes.draw do
  root 'static_pages#home'

  get 'static_pages/home'

  resources :posts, except: :index
  resources :comments, except: %i[ index show new ]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
  end
end
