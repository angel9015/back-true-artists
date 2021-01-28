# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :sessions do
        collection do
          post 'login' => 'sessions#create'
          delete 'logout' => 'sessions#destroy'
        end
      end

      resources :users
      resources :artists do
        resources :tattoos
      end
      resources :studios do
        resources :tattoos
        member do
          put :invite_artist
        end
      end
      resources :tattoos, only: %i[index show]
      resources :articles
    end
  end
end
