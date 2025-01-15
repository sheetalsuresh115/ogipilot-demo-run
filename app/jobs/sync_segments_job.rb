class SyncSegmentsJob < ApplicationJob
  include SyncSegmentsConverter

  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "SyncSegments"
    if session.consumer_session_exists
      session.read_messages().each do |message|
        read_sync_bod(Nokogiri::XML(message.content.to_s).to_xml, "//Segment")
        Rails.logger.debug("\n Read SyncSegments and added new FunctionalLocations")
        ActionCable.server.broadcast("notification_channel", {value: "Segment Sync completed." })
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end

    rescue StandardError => e
      Rails.logger.error("\n Sync Segments Job- Exception #{e}")
  end
end
