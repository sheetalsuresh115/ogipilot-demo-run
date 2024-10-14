class NotificationJob < ApplicationJob
  queue_as :default

  def perform(*args)

    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "BaseLineRisk"

    # TODO check this approach with Matt and then proceed.
    if session.consumer_session_exists
      session.read_messages().each do |message|
        update_equipment = Equipment.find_by(uuid: message.content[:uuid])
        if update_equipment.present?
          update_equipment.status_id = message.content[:status_id]
          update_equipment.alarm_id = message.content[:alarm_id]
          update_equipment.save
        end
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end
    redirect_to_source
  end
end
