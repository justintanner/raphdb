# prettier-ignore
Rails.application.routes.draw do
  # TODO: Move this into the "editor" namespace.
  devise_for :users
  get '/:slug', to: 'pages#show'

  root 'pages#show', slug: 'homepage'
end
