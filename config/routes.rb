# prettier-ignore
Rails.application.routes.draw do
  get '/:slug', to: 'pages#show'

  root 'pages#show', slug: 'homepage'
end
