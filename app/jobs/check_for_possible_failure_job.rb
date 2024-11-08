class CheckForPossibleFailureJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "PossibleFailure"
    if session.consumer_session_exists
      session.read_messages.each do |message|

        ### CALL THE CONVERTER HERE
        update_equipment = Equipment.find_by(uuid: message.content[:uuid])
        if update_equipment.present?
          update_equipment.update_status_and_alarm(message)
          ActionCable.server.broadcast("notification_channel", {equipment: update_equipment.uuid, value: "Possible Failure ~ Equipment #{update_equipment.id}" })
        end
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end

  end
end
