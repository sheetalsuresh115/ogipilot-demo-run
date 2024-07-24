class EquipmentCreationComponent < ViewComponent::Base

  def initialize(equipment: )
    @equipment = equipment
    # logger.debug "### Component initialized: #{@equipment.inspect}"
  end
end
