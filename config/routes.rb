# frozen_string_literal: true

# prettier-ignore
Rails.application.routes.draw do
  devise_for :users, path: "editor"

  namespace :editor do
    root to: "views#default"
    resources :views, only: [:show] do
      collection do
        get :default
      end
    end
  end

  get "/:slug", to: "pages#show"

  root "pages#show", slug: "homepage"
end
