require 'rufus-scheduler'

if defined?(Rails::Server)
  # Rufus Scheduler supports scheduling jobs every few seconds.
  scheduler = Rufus::Scheduler.new
  scheduler.every '3s' do
    # Active Job and SideKiq have separate job ids.
    job = LoadMeasurementsJob.perform_later
    # logger.debug "Measurement Job Id: "+job.provider_job_id
  end

  scheduler.every '2min' do
    # Active Job and SideKiq have separate job ids.
    job = CleanUpMeasurementsJob.perform_later
    # logger.debug "Measurement Job Id: "+job.provider_job_id
  end
end
