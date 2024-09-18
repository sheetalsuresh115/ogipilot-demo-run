class MeasurementChannel < ApplicationCable::Channel

  def subscribed
    # This method is called when the consumer successfully subscribes to this channel.
    stream_from "measurement_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
