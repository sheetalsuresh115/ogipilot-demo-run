require 'sidekiq/web'

Rails.application.routes.draw do

  root 'risk_dashboards#index'
  resources :risk_dashboards, :ogi_pilot_sessions, :equipment

  get 'risk_dashboards/load_measurements_component', to: 'risk_dashboards#load_measurements_component', as: :'load_measurements_component'
  get 'risk_dashboards/load_alarms_component_path', to: 'risk_dashboards#load_alarms_component', as: :'load_alarms_component'
  get 'risk_dashboards/load_active_component_path', to: 'risk_dashboards#load_active_component', as: :'load_active_component'
  get 'risk_dashboards/request_response', to: 'risk_dashboards#request_response', as: :'request_response'
  get 'risk_dashboards/publish_subscribe', to: 'risk_dashboards#publish_subscribe', as: :'publish_subscribe'
  get 'risk_dashboards/baseline_risk', to: 'risk_dashboards#baseline_risk', as: :'baseline_risk'

  resources :ogi_pilot_sessions do
    get 'open', on: :member
    get 'close', on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'

end
