Rails.application.routes.draw do
  root to: 'events#index'
  post '/event', to: 'events#check_alerts'
  match '*path', to: 'application#raise_not_found', via: :all
end
