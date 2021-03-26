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

      get 'me' => 'users#show'
      resources :users, only: %i[create show update destroy]

      resources :passwords do
        collection do
          put 'change_password' => 'passwords#update'
        end
      end
      resources :artists do
        collection do
          put 'verify-phone' => 'studios#verify_phone'
        end
        resources :tattoos
        member do
          delete 'delete-image/:image_id' => 'artists#remove_image'
          put :submit_for_review
        end
      end
      resources :studios do
        collection do
          put 'verify-phone' => 'studios#verify_phone'
        end
        resources :tattoos
        member do
          delete 'delete-image/:image_id' => 'studios#remove_image'
          put :submit_for_review
          get :guest_artist_applications
          get 'guest_artist_applications/:id' => 'studios#application'
        end
      end
      resources :locations, only: %i[index show]

      resources :studio_invites, path: 'studio-invites' do
        collection do
          post 'invite-artist' => 'studio_invites#create'
          get 'accept-invite' => 'studio_invites#accept_studio_invite'
        end
      end

      resources :favorites, only: %i[create] do
        collection do
          :delete
        end
      end

      resources :tattoos, only: %i[index show update] do
        collection do
          post 'batch-create' => 'tattoos#batch_create'
          get 'filter' => 'tattoos#filter'
        end
        member do
          put :flag
        end
      end
      resources :articles, only: %i[index show]
      resources :conventions, only: %i[index show]
      resources :styles
      resources :categories, only: %i[index show]
      resources :landing_pages, only: %i[show index]
      resources :guest_artist_applications, only: %i[create update destroy] do
        member do
          post :respond
        end
      end
    end
  end
end
