Rails.application.routes.draw do
  get '/event', to: 'events#index'
  match '*path', to: 'application#raise_not_found', via: :all
end
