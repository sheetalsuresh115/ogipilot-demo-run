# frozen_string_literal: true

class BreakDownStructuresComponent < ViewComponent::Base
  def initialize(source:, equipments:)
    @source = source
    @equipments = equipments
  end

end
