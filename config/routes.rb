# frozen_string_literal: true

Rails.application.routes.draw do
  # Sometimes rails is unable to db:drop db:create for RAILS_ENV=test, commenting out the below line fixes it, why?
  devise_for :users, path: "editor"

  namespace :editor do
    root to: "views#default"

    resources :single_selects, only: [:create]
    resources :multiple_selects, only: [:create]
    resources :items, only: [:edit, :update]
    resources :views, only: [:show] do
      collection do
        get :default
      end
      member do
        get :search
      end
    end
  end

  resources :items, only: [:index]

  get "/:slug", to: "pages#show"

  root "pages#show", slug: "homepage"
end
