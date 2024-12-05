class LoadMeasurementsJob < ApplicationJob
  queue_as :default

  def perform()
    #Assuming there is only 1 active Motor at a time.
    equip = Equipment.where("is_active = ? ", true).first
    measurement = Measurement.create(equipment: equip, time_stamp: Time.current.iso8601, data: Random.rand(60))
    measurement.save
    ActionCable.server.broadcast("measurement_channel", {equipment: measurement.equipment.id, value: measurement.get_json_chart_values() })

    rescue StandardError => e
      Rails.logger.error("\n Load Measurements Job- Exception #{e}")
  end
end
