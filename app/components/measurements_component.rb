# frozen_string_literal: true

class MeasurementsComponent < ViewComponent::Base
  def initialize(timestamps:, vibrations: )
    @timestamps = timestamps
    @vibrations = vibrations
  end
end
