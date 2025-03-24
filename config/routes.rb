Rails.application.routes.draw do
  get "chat/message"
  resources :experiences, except:[:index, :show]
  resource :session
  resources :passwords, param: :token
  resources :projects
  root "home#index"
  post '/chat/message', to: 'chat#message'
  get "up" => "rails/health#show", as: :rails_health_check
end
