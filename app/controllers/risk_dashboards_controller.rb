class RiskDashboardsController < ApplicationController

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
        session.post_base_line_risk_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body)
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
    end
  end

  def possible_failure
    begin
      session = OgiPilotSession.find_by topic: "PossibleFailure"
      if session && session.provider_session_exists
        session.post_possible_failure_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body)
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
    end
  end

  def failure
    begin
      session = OgiPilotSession.find_by topic: "Failure"
      if session && session.provider_session_exists
        session.post_failure_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body)
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
    end
  end

end
