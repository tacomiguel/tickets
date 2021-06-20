Rails.application.routes.draw do
  post 'geoutils/sync', to: 'geoutils#sync'

  namespace :api do
    namespace :v1 do
      resources :tickets, only: [:index, :create, :show, :update] do
        put :extend, on: :member
      end
    end
  end

  devise_for :users, skip: [:registrations, :passwords], controllers: {
    sessions: 'auth/users/sessions'
  }

  get 'tickets/bitacora/:id', to: "tickets#bitacora", as: "bitacora"
  get 'tickets/mail/:id', to: "tickets#mail", as: "mail"
  get 'ticket_questions/nuevo/:id', to: "ticket_questions#nuevo", as: "nuevo"
  get 'ticket_questions/actividades/:id', to: "ticket_questions#actividades", as: "actividades"
  get 'ticket_questions/listar/:id', to: "ticket_questions#listar", as: "listar"
  get 'ticket_questions/email/:id', to: "ticket_questions#email", as: "email"
  get 'ticket_issues/showimei/:id', to: "ticket_issues#showimei", as: "showimei"

   get '/checkhealth', to: proc { [200, {}, ['OK-[tickets2]']] }

  resources :clients, except: %i[ destroy ]
  resources :departaments
  resources :ticket_statuses
  resources :ticket_priorities
  resources :ticket_sources
  resources :ticket_reasons
  resources :reports
  resources :ticket_questions
  resources :ticket_issues
  resources :tickets, except: %i[ destroy ] do
    resources :ticket_threads, only: %i[ index, create ]
  end

  root to: 'tickets#index'
end
