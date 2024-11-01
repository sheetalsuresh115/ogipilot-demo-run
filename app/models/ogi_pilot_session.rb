class OgiPilotSession < ApplicationRecord
  has_secure_password
  validates :end_point, presence: true
  validates :channel, presence: true
  validates :topic, presence: true
  validates :message_type, presence: true
  validates :user_name, presence: true

  attr_accessor :validation_messages

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
    self.save!
    logger.debug "Session opened successfully"

    rescue StandardError, IsbmAdaptor::ChannelFault, IsbmAdaptor::SessionFault, IsbmAdaptor::ParameterFault,
      IsbmAdaptor::IsbmFault => e
      logger.debug " Exception during opening new session: #{e}"
      flash[:alert] = "Exception during opening new session: #{e}"
      if self.consumer_session_id.present?
        logger.debug " Closing new consumer session: #{self.consumer_session_id}"
        client_details[:consumer_client].close_session(self.consumer_session_id)
      end

      if self.provider_session_id.present?
        logger.debug " Closing new provider session: #{self.provider_session_id}"
        client_details[:provider_client].close_session(self.provider_session_id)
      end
  end

  def close_session
    client_details = get_consumer_provider_details()
    if self.consumer_session_id.present?
      client_details[:consumer_client].close_session(self.consumer_session_id)
      self.consumer_session_id = nil
    end

    if self.provider_session_id.present?
      client_details[:provider_client].close_session(self.provider_session_id)
      self.provider_session_id = nil
    end

    self.save!
    logger.debug "Session closed successfully"
    self.validation_messages = "Session closed successfully."

    rescue IsbmAdaptor::SessionFault, IsbmAdaptor::ChannelFault, IsbmAdaptor::ParameterFault, IsbmAdaptor::IsbmFault, StandardError => e
      # In this scenario, looks best to create new sessions so that the user can delete the session in the next go from the UI.
      logger.debug " Opening the consumer session to avoid manual intervention:"
      self.consumer_session_id = client_details[:consumer_client].open_session(self.channel, [self.topic])
      logger.debug " Opening the provider session to avoid  manual intervention:"
      self.provider_session_id = client_details[:provider_client].open_session(self.channel)

      logger.debug " An error occured, please try closing the session again: #{e}"
      self.validation_messages = "An error occured, please try closing the session again."

      self.save
  end

  def post_base_line_risk_message
    client_details = get_consumer_provider_details()
    # For demo only
    update_equipment = Equipment.find_by(uuid:"9c6dd4d2-7cc4-4207-9d61-b7ec3f69d176")
    update_equipment.status_id = LifeCycleStatusHelper::DANGER
    update_equipment.alarm_id = AlarmHelper::ABNORMAL
    posted_message_id = client_details[:provider_client].post_publication(self.provider_session_id, update_equipment, [self.topic])
    logger.debug "Posted message: #{posted_message_id}"
  end

  def post_possible_failure_message
    client_details = get_consumer_provider_details()
    # For demo only
    update_equipment = Equipment.find_by(uuid:"40fd2683-4a0c-4e9d-b5ee-d8268ad017f2")
    update_equipment.status_id = LifeCycleStatusHelper::ALERT
    update_equipment.alarm_id = AlarmHelper::ABNORMAL_FREQUENCIES
    posted_message_id = client_details[:provider_client].post_publication(self.provider_session_id, update_equipment, [self.topic])
    logger.debug "Posted message: #{posted_message_id}"
  end

  def read_messages
    client_details = get_consumer_provider_details()
    messages = Array.new()
    while message = client_details[:consumer_client].read_publication(self.consumer_session_id) do
      messages.push(message)
      client_details[:consumer_client].remove_publication(self.consumer_session_id)
      puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
    end
    return messages
  end

end
