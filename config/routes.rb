Rails.application.routes.draw do
  root to: 'events#index'
  get '/event', to: 'events#index'
  match '*path', to: 'application#raise_not_found', via: :all
end
