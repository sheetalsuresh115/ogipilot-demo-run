class EquipmentCreationComponent < ViewComponent::Base

  def initialize(equipment:, source: )
    @equipment = equipment
    @source = source
    # logger.debug "### Component initialized: #{@equipment.inspect}"
  end
end
