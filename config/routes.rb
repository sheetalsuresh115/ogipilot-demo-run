Rails.application.routes.draw do
  root 'risk_dash_board#index'

  get 'components/equipments', to: 'components#equipments'
  get 'risk_dash_board/load_equipment_component', to: 'risk_dash_board#load_equipment_component', as: :'load_equipment_component'
  get 'risk_dash_board/load_measurements_component', to: 'risk_dash_board#load_measurements_component', as: :'load_measurements_component'
  get 'risk_dash_board/load_alarms_component_path', to: 'risk_dash_board#load_alarms_component', as: :'load_alarms_component'
  get 'risk_dash_board/load_active_component_path', to: 'risk_dash_board#load_active_component', as: :'load_active_component'
  get 'risk_dash_board/session_management', to: 'risk_dash_board#session_management', as: :'session_management'
  get 'risk_dash_board/new_session_management', to: 'risk_dash_board#load_new_session_management_component', as: :'new_session_management'
  get 'risk_dash_board/request_response', to: 'risk_dash_board#request_response', as: :'request_response'
  get 'risk_dash_board/publish_subscribe', to: 'risk_dash_board#publish_subscribe', as: :'publish_subscribe'
  resources :risk_dash_board
  resources :equipments
  resources :session_management
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  #root "posts#index"
end
