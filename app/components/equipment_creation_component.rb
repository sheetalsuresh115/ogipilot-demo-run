class EquipmentCreationComponent < ViewComponent::Base

  def initialize(equipment:, source: )
    # Source here indicates the origin of this request, it could be from Alarms or from Break Down Structures.
    # After the object gets "created", it gets redirected to its source based on this parameter.
    @equipment = equipment
    @source = source
  end
end
