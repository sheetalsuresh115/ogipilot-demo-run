require 'rufus-scheduler'

if defined?(Rails::Server)
  # Initialize the scheduler
  scheduler = Rufus::Scheduler.new
  scheduler.every '3s' do
    LoadMeasurementsJob.perform_now
  end
end
