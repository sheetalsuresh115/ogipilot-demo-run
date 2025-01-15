module LifeCycleStatusHelper
  NORMAL = 0
  WARNING = 1
  ALERT = 2
  DANGER = 3
  UNDETERMINED = 4

  # Returns a list of objects to be populated as a dropdown
  def get_life_cycle_status
    return [
      OpenStruct.new(id: NORMAL, name: "Normal"),
      OpenStruct.new(id: WARNING, name: "Warning"),
      OpenStruct.new(id: ALERT, name: "Alert"),
      OpenStruct.new(id: DANGER, name: "Danger"),
      OpenStruct.new(id: UNDETERMINED, name: "Undetermined")
    ]
  end

  # This function returns the status type and description.
  def get_status_type_and_description(status)

    case status.to_i
    when NORMAL
      return "alert-success", "NORMAL"
    when WARNING
      return "alert-warning", "WARNING"
    when ALERT
      return "alert-info", "ALERT"
    when DANGER
      return "alert-danger", "DANGER"
    when UNDETERMINED
      return "alert-secondary", "UNDETERMINED"
    end
  end

  # Defining this method as a class method.
  module_function :get_status_type_and_description, :get_life_cycle_status

end
