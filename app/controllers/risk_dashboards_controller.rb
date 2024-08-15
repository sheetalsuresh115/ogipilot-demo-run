class RiskDashboardsController < ApplicationController

  $break_down_structure_notification = 0
  $measurements_notification = 0
  $alarms_notification = 0
  $active_components_notification = 0
  $standby_components_notification = 0

  def index
  end

  def show
    @equipments = Equipment.all
  end

  def load_measurements_component
    # Assuming that once the SyncMeasurement gets deserialized into an object,
    # we could fetch the timestamp and measurement data from it.

    timestamp_labels = []
    10.times do |i|
      timestamp_labels << (Time.current + i.minutes).strftime("%H:%M:%p")
    end

    @labels = timestamp_labels
    @datasets = [12, 19, 3, 5, 2, 12, 4, 8, 2, 20]
  end

  def load_alarms_component
    @alarms = Equipment.all
  end

  def load_active_component
    @active = Equipment.all
  end

  def load_standby_component
    @standby = Equipment.all
  end

  def baseline_risk
    begin
      @session = OgiPilotSession.find_by topic: "BaseLineRisk"
      #An equipment at risk is published.
      #TBD
      #This is supposed to be done externally, where SyncStatus messages will be published.
      @update_equipment = Equipment.find_by(uuid:"9c6dd4d2-7cc4-4207-9d61-b7ec3f69d176")
      @update_equipment.status_id = LifeCycleStatusHelper::DANGER
      @update_equipment.alarm_id = AlarmHelper::ABNORMAL
      if @session.provider_session_id.present?
        publish_client = IsbmRestAdaptor::ProviderPublication.new
        #In the future, for the DEMO this is where the BOD that contains Risk Data should be published.
        posted_message_id = publish_client.post_publication(@session.provider_session_id, @update_equipment, [@session.topic])
        puts "Posted message: #{posted_message_id}"

        #This should be updated when the Job receives a message and has not read it yet.
        #TBD
        $break_down_structure_notification += 1
        $alarms_notification += 1
        $measurements_notification += 1
        redirect_to risk_dashboards_path
      else
        redirect_to risk_dashboards_path, alert: 'Please open a valid session!'
      end

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body)
      # for REST path, cannot tell difference between no session and no message, so make a guess
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
    end
  end
end
