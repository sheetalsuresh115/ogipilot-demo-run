class RiskDashboardsController < ApplicationController

  $break_down_structure_notification = 0
  $measurements_notification = 0
  $alarms_notification = 0
  $active_components_notification = 0
  $standby_components_notification = 0

  def measurements
    # Using ActionCables, data will be live streamed.
    measurements = Measurement.last(10)
    timestamp_labels = []
    datasets = []
    measurements.each do |measurement_obj|
      timestamp_labels.push(measurement_obj.time_stamp)
      datasets.push(measurement_obj.data)
    end
    @timestamps = timestamp_labels
    @vibrations = datasets
  end

  def active_standby
    @equipments = Equipment.all
  end

  def baseline_risk
    begin
      session = OgiPilotSession.find_by topic: "BaseLineRisk"
      if session && session.provider_session_exists
        session.post_messages
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = "Please open a valid session!"
        redirect_back(fallback_location: root_path)
      end

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body)
      # for REST path, cannot tell difference between no session and no message, so make a guess
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
    end
  end
end
