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
    resources :views, only: [:show, :update, :destroy] do
      collection do
        get :default, as: :default
      end
      member do
        post :refresh, as: :refresh
        post :duplicate, as: :duplicate
      end

      resources :filters, except: [:index, :show, :destroy], shallow: true do
        collection do
          delete :destroy_by_uuid, as: :destroy_by_uuid
        end
      end

      resources :sorts, except: [:index, :show, :destroy], shallow: true do
        collection do
          patch :reorder_by_uuid, as: :reorder_by_uuid
          delete :destroy_by_uuid, as: :destroy_by_uuid
        end
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

  get "/error", to: "errors#index", as: :error
  get "/:slug", to: "pages#show"
  root "pages#show", slug: "homepage"
end
