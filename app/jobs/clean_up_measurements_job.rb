class CleanUpMeasurementsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    total_rows = Measurement.count
    if total_rows > 100
      latest_ids = Measurement.order(created_at: :desc).limit(10).pluck(:id)
      Measurement.where.not(id: latest_ids).delete_all
    end
    rescue StandardError => e
      Rails.logger.error("\n Clean Up Measurements Job - Exception #{e}")
  end

end
