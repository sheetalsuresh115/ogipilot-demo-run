class SyncAssetsJob < ApplicationJob
  include SyncAssetsConverter
  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "SyncAssets"
    if session.consumer_session_exists
      session.read_messages().each do |message|
        _ = read_sync_bod(Nokogiri::XML(message.content.to_s).to_xml, "//Asset")
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end
    rescue StandardError => e
      Rails.logger.error("\n Sync Asset Job - Exception #{e}")
  end
end
