module SyncSegmentsConverter
  include BodConverter
  def process_sync_noun(noun)
    segment_noun = noun[:segment]
    segment_noun[:childComponent].each do |child_component|
      process_sync_child_components(child_component)
    end
    Rails.logger.debug "\n Functional Location  successfully created"
    return "sync_complete"
    rescue StandardError => e
      Rails.logger.error("\n Functional Location COULD NOT be created #{e}")
  end

  def process_sync_child_components(segment)

    # If the child Component has children, then break down structures are added ( parent / child info is stored)
    # Safe check - if not present, the value is nil and nil.each throws an exception
    if segment[:child][:childComponent].present?
      segment[:child][:childComponent].each do |component|
        process_sync_child_components(component)
        bds = BreakDownStructure.find_or_initialize_by uuid: SecureRandom.uuid
        bds.to = component[:child][:uUID]
        bds.from = segment[:child][:uUID]
        bds.save!
        floc = FunctionalLocation.find_or_initialize_by uuid: component[:child][:uUID]
        floc.assign_values_to_floc_from_sync_segments(component[:child], bds)
        floc.save!
      end
    else
      floc = FunctionalLocation.find_or_initialize_by uuid: segment[:child][:uUID]
      floc.assign_values_to_floc_from_sync_segments(segment[:child], nil)
      floc.save!
    end
  end

end
