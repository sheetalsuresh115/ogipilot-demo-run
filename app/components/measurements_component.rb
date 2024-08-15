# frozen_string_literal: true

class MeasurementsComponent < ViewComponent::Base
  def initialize(labels:, datasets: )
    @labels = labels
    @datasets = datasets
  end
end
