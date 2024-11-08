class CheckForFailureJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "Failure"
    if session.consumer_session_exists
      session.read_messages().each do |message|
        update_equipment = Equipment.find_by(uuid: message.content[:uuid])
        if update_equipment.present?
          update_equipment.update_status_and_alarm(message)
          ActionCable.server.broadcast("notification_channel", {equipment: update_equipment.uuid, value: "Failure ~ Equipment #{update_equipment.id}" })

          # The standby equipment should be activated and the details updated in the BreakdownStructure
          # update_equipment = Equipment.where(functional_location_id: message.content[:uuid])
        end
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end

  end
end