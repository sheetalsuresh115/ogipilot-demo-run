class PubSubSchedulerJob < ApplicationJob
  queue_as :default

  def perform( *args)
    topic = args.first[:topic]
    provider_session_id = args.first[:provider_session_id]
    consumer_session_id = args.first[:consumer_session_id]
    confirmation_session_id = args.first[:confirmation_session_id]

    rescue StandardError => e
      Rails.logger.error("\n Load Measurements Job- Exception #{e}")

  end

end
