# frozen_string_literal: true

class BreakDownStructuresComponent < ViewComponent::Base
  # This component is used to display the hierarchy of the functional location and its assets.

  def initialize(source_dict:, equipments:)
    # Source here indicates the origin of this request, it could be from Alarms or from Break Down Structure itself.
    @source_dict = source_dict
    @equipments = equipments
  end
end
