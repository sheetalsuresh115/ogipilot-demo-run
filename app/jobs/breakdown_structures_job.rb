class BreakdownStructuresJob < ApplicationJob
  queue_as :default

  def perform( *args)
    $topic = args.first[:topic]
    $provider_session_id = args.first[:provider_session_id]
    $consumer_session_id = args.first[:consumer_session_id]
    $confirmation_session_id = args.first[:confirmation_session_id]
  end

  def perform(*args)
    subscribe_client = IsbmRestAdaptor::ConsumerPublication.new
    message = subscribe_client.read_publication(subscribe_session_id)
    puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
  end
end
