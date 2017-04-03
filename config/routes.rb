Rails.application.routes.draw do
  root 'static_pages#home'

  get '/finish', to: 'static_pages#finish'

  end
