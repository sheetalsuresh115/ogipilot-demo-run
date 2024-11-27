class SyncActualEventsJob < ApplicationJob
  include SyncActualEventsConverter

  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "SyncActualEvents"
    if session.consumer_session_exists
      session.read_messages().each do |message|
        read_sync_bod(Nokogiri::XML(message.content.to_s).to_xml, "//ActualEvent")
        Rails.logger.debug("\n Read SyncActualEvents and stored informatin ")
        ActionCable.server.broadcast("notification_channel", {value: "Actual Events Sync completed." })
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end
    rescue StandardError => e
      Rails.logger.error("\n Sync Actual Events Job - Exception #{e}")
  end
end
