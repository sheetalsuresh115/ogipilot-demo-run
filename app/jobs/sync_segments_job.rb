class SyncSegmentsJob < ApplicationJob
  include SyncSegmentsConverter

  queue_as :default

  def perform(*args)
    # If the session exists and messages have been received, then the appropriate notifications will be sent.
    session = OgiPilotSession.find_by topic: "SyncSegments"
    if session.consumer_session_exists
      session.read_messages().each do |message|
        _ = read_sync_bod(Nokogiri::XML(message.content.to_s).to_xml)
      end
    else
      flash[:alert] = "Session does not exist. Please open a valid session."
    end
  end
end
