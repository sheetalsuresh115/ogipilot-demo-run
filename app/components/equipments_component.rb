# frozen_string_literal: true

class EquipmentsComponent < ViewComponent::Base
  def initialize(equipments:)
    @equipments = equipments
  end
end
