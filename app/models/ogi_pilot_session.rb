class OgiPilotSession < ApplicationRecord
  has_secure_password
  validates :end_point, presence: true
  validates :channel, presence: true
  validates :topic, presence: true
  validates :message_type, presence: true
  validates :user_name, presence: true

  def provider_session_exists
    return self.provider_session_id.present?
  end

  def consumer_session_exists
    return self.consumer_session_id.present?
  end

  def get_consumer_provider_details
    # This function returns a new provider and consumer object.
    return { consumer_client: IsbmRestAdaptor::ConsumerPublication.new, provider_client: IsbmRestAdaptor::ProviderPublication.new }
  end

  def open_session
    client_details = get_consumer_provider_details()
    self.consumer_session_id = client_details[:consumer_client].open_session(self.channel, [self.topic])
    self.provider_session_id = client_details[:provider_client].open_session(self.channel)
    self.save
  end

  def close_session
    client_details = get_consumer_provider_details()
    client_details[:consumer_client].close_session(self.consumer_session_id)
    client_details[:provider_client].close_session(self.provider_session_id)
    self.consumer_session_id = nil
    self.provider_session_id = nil
    self.save
  end

  def post_messages
    client_details = get_consumer_provider_details()
    #In the future, for the DEMO this is where the BOD that contains Risk Data should be published.
    update_equipment = Equipment.find_by(uuid:"9c6dd4d2-7cc4-4207-9d61-b7ec3f69d176")
    update_equipment.status_id = LifeCycleStatusHelper::DANGER
    update_equipment.alarm_id = AlarmHelper::ABNORMAL
    posted_message_id = client_details[:provider_client].post_publication(self.provider_session_id, update_equipment, [self.topic])
    puts "Posted message: #{posted_message_id}"

    $break_down_structure_notification += 1
    $alarms_notification += 1
    $measurements_notification += 1
  end

  def read_messages
    client_details = get_consumer_provider_details()
    messages = Array.new()
    while message = client_details[:consumer_client].read_publication(self.consumer_session_id) do
      messages.push(message)
      client_details[:consumer_client].remove_publication(self.consumer_session_id)
      puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
      $break_down_structure_notification -= 1
      $alarms_notification -= 1
      $measurements_notification -= 1
    end
    return messages
  end

end
