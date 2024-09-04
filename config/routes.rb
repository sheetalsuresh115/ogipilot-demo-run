require 'sidekiq/web'

Rails.application.routes.draw do
  root 'risk_dashboards#index'

  controller :risk_dashboards do
    get 'load_measurements_component', action: :load_measurements_component, as: :load_measurements_component
    # load_alarms_component_path - Just a placeholder - will remove it once the other trigger events are implemented
    get 'load_alarms_component_path', action: :load_alarms_component, as: :load_alarms_component
    get 'load_active_component_path', action: :load_active_component, as: :load_active_component
    get 'publish_subscribe', action: :publish_subscribe, as: :publish_subscribe
    get 'baseline_risk', action: :baseline_risk, as: :baseline_risk
  end

  resources :ogi_pilot_sessions do
    get 'open', on: :member
    get 'close', on: :member
  end

  #equipment is plural and hence equipment_index_path is the index path for equipment.
  resources :risk_dashboards, :ogi_pilot_sessions, :equipment
  get 'check_for_risk', to: 'equipment#check_for_risk'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => '/sidekiq'

end
