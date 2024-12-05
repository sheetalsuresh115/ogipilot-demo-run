class SyncBreakDownStructuresJob < ApplicationJob
  include SyncBreakDownStructuresConverter
  queue_as :default

  def perform(*args)
    begin
      # If the session exists and messages have been received, then the appropriate notifications will be sent.
      session = OgiPilotSession.find_by topic: "SyncBreakDownStructures"
      if session.consumer_session_exists
        session.read_messages().each do |message|
          read_sync_bod(Nokogiri::XML(message.content.to_s).to_xml, "//BreakdownStructure")
          Rails.logger.debug("\n Read SyncBreakDownStructures and added new connections to the db.")
          ActionCable.server.broadcast("notification_channel", {value: "BreakDownStructures Sync completed." })
        end
      else
        flash[:alert] = "Session does not exist. Please open a valid session."
      end

    rescue StandardError => e
      Rails.logger.error("\n Sync BreakDownStructures Job- Exception #{e}")
    end
  end


end
