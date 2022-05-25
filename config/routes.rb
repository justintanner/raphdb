# frozen_string_literal: true

Rails.application.routes.draw do
  # Sometimes rails is unable to db:drop db:create for RAILS_ENV=test, commenting out the below line fixes it, why?
  devise_for :users, path: "editor"

  namespace :editor do
    root to: "views#default"

    resources :single_selects, only: [:create]
    resources :multiple_selects, only: [:create]
    resources :items, only: [:edit, :update]
    resources :images, only: [:create, :update, :destroy] do
      member do
        get :edit
      end
    end
    resources :views, only: [:show] do
      collection do
        get :default, as: :default
      end
      member do
        get :search
      end
    end
    resources :pages, only: [:edit, :update]
    resource :settings, only: [:create]
  end

  resources :items, only: [:index, :show] do
    member do
      get "picture/:picture_number", to: "items#show", as: :picture
    end
  end

  resources :item_sets, path: "sets", only: [:show]

  get "/:slug", to: "pages#show"

  root "pages#show", slug: "homepage"
end
