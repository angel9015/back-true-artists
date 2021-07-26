# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope module: 'frontend' do
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
      member do
        get :tattoos
      end

      collection do
        get 'register' => 'artists#home'
        get 'city/:city_state' => 'artists#city', as: :city_state
      end
    end

    resources :studios do
      member do
        get :tattoos
        get :artists
      end

      collection do
        get 'city/:city_state' => 'studios#city', as: :city_state
      end
    end

    resources :locations, only: %i[index show]

    resources :favorites, only: %i[create] do
      collection do
        :delete
      end
    end

    resources :tattoos, only: %i[index show] do
      collection do
        get '/placement/:placement' => 'tattoos#facet', as: :placement
        get '/style/:style' => 'tattoos#facet', as: :style
      end
    end

    resources :articles, only: %i[index show], path: 'blog' do
      collection do
        get 'categories' => 'categories#index', as: :blog_categories
        get 'categories/:id' => 'categories#show', as: :blog_category
      end
    end

    resources :conventions, only: %i[index show] do
      collection do
        get 'city/:city_state' => 'conventions#city', as: :city_state
      end
    end

    resources :pages, only: %i[index show]

    resources :styles
    resources :categories, only: %i[index show]
    resources :landing_pages, only: %i[show index]
    resources :global_search_redirector, only: [:index]
    root to: 'landing_pages#home'
    get '/register/artist' => 'artists#register'
    get '/about-us' => 'landing_pages#about_us'
    get '/contact-us' => 'landing_pages#contact_us'
  end

  direct :asset_blob do |blob|
    # Preserve the behaviour of `rails_blob_url` inside these environments
    # where S3 or the CDN might not be configured
    if Rails.env.development? || Rails.env.test?
      route_for(:rails_blob, blob)
    else
      # Use an environment variable instead of hard-coding the CDN host
      # You could also use the Rails.configuration to achieve the same
      File.join(ENV.fetch('CDN_HOST'), blob.key)
    end
  end
end
