Rails.application.routes.draw do
    resources :users do
        resources :gamestates
    end
    resources :gamestates
    resources :locations
    resources :items

    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    post "/signup", to: "users#create"
    get "/me", to: "users#show"

    # handles all other GET requests by sending them to a special FallbackController
    get "*path", to: "fallback#index", constraints: ->(req) { !req.xhr? && req.format.html? }
end
