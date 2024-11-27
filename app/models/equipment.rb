class Equipment < ApplicationRecord

  validates :uuid, presence: true
  validates :id_in_source, presence: true
  validates :short_name, presence: true
  validates :status_id, presence: true
  validates :alarm_id, presence: true
  validates :is_active, presence: true
  validates :asset_type, presence: false
  validates :manufacturer, presence: false
  validates :model, presence: false
  validates :serial_number, presence: false
  validates :site_id, presence: false
  belongs_to :functional_location, optional: true

  def update_status_and_alarm(message)
    self.status_id = message.content[:status_id]
    self.alarm_id = message.content[:alarm_id]
    self.save!
    logger.debug "Equipment Status and Alarm updated successfully"

    rescue StandardError => e
      logger.debug " Exception during status update #{e}"
  end

  def assign_values_to_asset_from_sync_assets(asset_info, floc)
    self.id_in_source = asset_info[:infoSource][:uUID]
    self.short_name = asset_info[:shortName]
    self.asset_type = asset_info[:type][:uUID]
    self.manufacturer = asset_info[:manufacturer][:uUID]
    self.model = asset_info[:model][:uUID]
    self.serial_number = asset_info[:serialNumber]
    self.status_id = asset_info[:presentLifecycleStatus][:uUID]
    self.alarm_id = asset_info[:presentLifecycleStatus][:uUID]
    self.site_id = asset_info[:registrationSite][:uUID]
    self.is_active = true
    self.functional_location = floc
  end

end
