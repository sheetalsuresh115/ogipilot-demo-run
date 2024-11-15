require 'rufus-scheduler'

if defined?(Rails::Server)
  # Rufus Scheduler supports scheduling jobs every few seconds.
  scheduler = Rufus::Scheduler.new

  scheduler.every '3s' do
    # Active Job and SideKiq have separate job ids.
    job = LoadMeasurementsJob.perform_later
    # logger.debug "Measurement Job Id: #{job.provider_job_id}"
    job = CheckForBaseLineRiskJob.perform_later
    job = CheckForPossibleFailureJob.perform_later
    job = CheckForFailureJob.perform_later
    job = SyncSegmentsJob.perform_later
    job = SyncAssetsJob.perform_later
  end

  scheduler.every '2min' do
    job = CleanUpMeasurementsJob.perform_later
    # logger.debug "CleanUpMeasurementsJob Job Id: #{job.provider_job_id}"
  end

end
