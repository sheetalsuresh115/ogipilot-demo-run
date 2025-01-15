class ActiveStandbyComponent < ViewComponent::Base
  def initialize(equipments: )
    @equipments = equipments
  end
end
