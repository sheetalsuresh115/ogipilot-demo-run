require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  root 'risk_dashboards#index'

  controller :risk_dashboards do
    get 'measurements', action: :measurements, as: :measurements
    get 'active_standby', action: :active_standby, as: :active_standby
    get 'publish_subscribe', action: :publish_subscribe, as: :publish_subscribe
    get 'baseline_risk', action: :baseline_risk, as: :baseline_risk
    get 'possible_failure', action: :possible_failure, as: :possible_failure
    get 'failure', action: :failure, as: :failure
    get 'sync_segment', action: :sync_segment, as: :sync_segment
  end

  resources :ogi_pilot_sessions do
    get 'open', on: :member
    get 'close', on: :member
  end

  # equipment is plural and hence equipment_index_path is the index path for equipment.
  resources :ogi_pilot_sessions, :equipment

  resources :measurements, only: [:create]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'
end
