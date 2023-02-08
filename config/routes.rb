Rails.application.routes.draw do
  resources :gamestates
  resources :locations
  resources :items

  # route to test your configuration
  get '/hello', to: 'application#hello_world'

  # handles all other GET requests by sending them to a special FallbackController
  get '*path',
      to: 'fallback#index',
      constraints: ->(req) { !req.xhr? && req.format.html? }
end
