class MeasurementChannel < ApplicationCable::Channel

  # This should be send by the external client ?
  # and the data would be available to read in the channel.
  periodically every: 3.seconds do
    transmit value: rand(20), timestamp: Time.now.to_i
  end

  def subscribed
    # This method is called when the consumer successfully subscribes to this channel.
    stream_from "measurement_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
