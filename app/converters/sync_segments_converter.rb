module SyncSegmentsConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      segment_noun = noun[:segment]
      segment_noun[:childComponent].each do |child_component|
        process_sync_child_components(child_component)
        add_floc_and_break_down_structure(segment_noun, child_component)
      end

      Rails.logger.debug "\n Functional Location  successfully created"
    rescue StandardError => e
      Rails.logger.error("\n Functional Location COULD NOT be created #{e}")
    end
  end

  def process_sync_child_components(segment)
    # If the child Component has children, then break down structures are added ( parent / child info is stored)
    # Safe check - if not present, the value is nil and nil.each throws an exception
    if segment.dig("child","childComponent").present?
      segment.dig("child","childComponent").each do |component|
        process_sync_child_components(component)
        add_floc_and_break_down_structure(segment.dig("child"), component)
      end
    else
      floc = FunctionalLocation.find_or_initialize_by uuid: segment.dig("child","uUID")
      floc.assign_values_to_floc_from_sync_segments(segment.dig("child"), nil)
      floc.save!
    end
  end

  def add_floc_and_break_down_structure(parent, child)

    bds = BreakDownStructure.find_or_initialize_by uuid: SecureRandom.uuid
    bds.from_uuid = parent.dig("uUID")
    bds.to_uuid = child.dig("child","uUID")
    bds.save!

    floc = FunctionalLocation.find_or_initialize_by(uuid: parent.dig("uUID"), break_down_structure: bds)
    floc.assign_values_to_floc_from_sync_segments(parent, bds)
    floc.save!
  end

end
