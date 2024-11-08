class Equipment < ApplicationRecord
  validates :uuid, presence: true
  validates :id_in_source, presence: true
  validates :functional_location_id, presence: true
  validates :short_name, presence: true
  validates :segment_uuid, presence: true
  validates :status_id, presence: true
  validates :alarm_id, presence: true
  validates :is_active, presence: true

  def update_status_and_alarm(message)
    self.status_id = message.content[:status_id]
    self.alarm_id = message.content[:alarm_id]
    self.save!
    logger.debug "Equipment Status and Alarm updated successfully"

    rescue StandardError => e
      logger.debug " Exception during status update #{e}"
  end
end
