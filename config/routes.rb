# prettier-ignore
Rails.application.routes.draw do
  get '/:slug', to: 'pages#show', constraints: { slug: Page.pluck(:slug) }

  root 'pages#show', slug: 'homepage'
end
