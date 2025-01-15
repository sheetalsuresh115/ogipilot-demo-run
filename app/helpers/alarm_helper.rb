module AlarmHelper
  NORMAL = 0
  FLUCTUATING = 1
  ABNORMAL_FREQUENCIES = 2
  ABNORMAL = 3
  RECORDED = 4

  # Returns a list of objects to be populated as a dropdown
  def get_alarms
    return [
      OpenStruct.new(id: NORMAL, name: "Normal"),
      OpenStruct.new(id: FLUCTUATING, name: "Fluctuating"),
      OpenStruct.new(id: ABNORMAL_FREQUENCIES, name: "Abnormal Frequencies"),
      OpenStruct.new(id: ABNORMAL, name: "Abnormal"),
      OpenStruct.new(id: RECORDED, name: "Recorded")
    ]
  end

  # This function returns the alarm status type and description.
  def get_status_type_and_description(status)

    case status.to_i
    when NORMAL
      return "alert-success", "NORMAL"
    when FLUCTUATING
      return "alert-warning", "FLUCTUATING"
    when ABNORMAL_FREQUENCIES
      return "alert-info", "ABNORMAL_FREQUENCIES"
    when ABNORMAL
      return "alert-danger", "ABNORMAL"
    when RECORDED
      return "alert-secondary", "RECORDED"
    end
  end

  # Defining this method as a class method.
  module_function :get_status_type_and_description, :get_alarms
end
