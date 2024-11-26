module SyncActualEventsConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      floc = FunctionalLocation.find_by uuid: noun.dig("actualEvent", "entity", "uUID")
      unless floc.present?
        floc = create_missing_floc(noun.dig("actualEvent", "entity"), "SyncActualEvents")
      end

      noun.dig("actualEvent", "attributeSetForEntity", "attributeSet", "group", "group").each do |group|
        # Loops through all the attributes in all the groups and adds the actual events to the db.
        group[:setAttribute].each do |event_info|
          values = extract_from_value_content(event_info)
          ActualEvent.create(uuid: noun.dig("actualEvent", "uUID"), group_uuid: group[:uUID], attribute_type: event_info.dig("type","uUID"),
            value: values[:value], uom: values[:uom], functional_location: floc)
        end

      end

      # Outer Group => Event Type
      value = noun.dig("actualEvent","attributeSetForEntity","attributeSet","group","setAttribute","valueContent","enumerationItem","uUID")
      uom = ''
      ActualEvent.create(uuid: noun.dig("actualEvent","uUID"), group_uuid: noun.dig("actualEvent","attributeSetForEntity","attributeSet","group","uUID"),
      attribute_type: attribute.dig("type","uUID"), value: value, uom: uom, functional_location: floc)

      Rails.logger.debug "\n Actual Events successfully added"

    rescue StandardError => e
      Rails.logger.error("\n Actual Events COULD NOT be added - #{e}")
    end
  end

  def extract_from_value_content(event_info)
    uom = ''
    case event_info.dig("type","uUID")
    when "fa117d40-7c0c-013a-863c-13e41042e53e" # REPLACE WITH LOOKUP - TODO # prob of event
      value = event_info.dig("valueContent","probability")
    when "1abb1fe0-9145-013a-e43a-479c6bda2156" # probability of confidence
      value = event_info.dig("valueContent","percentage")
    when "a511da90-912b-013a-e43a-479c6bda2156", "c371c080-80a1-013a-863c-13e41042e53e" # start and end timestamp
      value = event_info.dig("valueContent","uTCDateTime")
    when "a35e86e5-dae9-4f28-8b3e-75ad62c0c88c" # Cost, Total Impact, Estimated
      value = event_info.dig("valueContent","measure","value")
      uom = event_info.dig("valueContent","measure","unitOfMeasure","uUID")
    when "f16fb670-8bc0-013a-0fc4-27ff9252943f", "47cb7e10-8706-013a-0fc4-27ff9252943f", "52b0dd80-870f-013a-0fc4-27ff9252943f"
      # Breakdwnstrcutre & functional location & Serialised asset
      value = event_info.dig("valueContent","uUID")
    end

    values = { value: value, uom: uom }
    return values

  end

end
