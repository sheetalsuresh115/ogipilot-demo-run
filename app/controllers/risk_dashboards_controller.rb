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
    @measurements = Equipment.all
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
      if @session.provider_session_id.present?
        publish_client = IsbmRestAdaptor::ProviderPublication.new
        #In the future, this is where the BOD that contains Risk Data should be published.
        posted_message_id = publish_client.post_publication(@session.provider_session_id, 'Test content Part 2', [@session.topic])
        puts "Posted message: #{posted_message_id}"

        $break_down_structure_notification = $break_down_structure_notification + 1
        redirect_to risk_dashboards_path, notice: 'Triggering Risk Info BreakDown'
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
