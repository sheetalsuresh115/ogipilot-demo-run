module SyncSegmentsConverter

  def read_sync_bod(bod_new, opts={})
    floc_change = []

    bod_new.remove_namespaces!

    # process noun with collected update fields and values
    bod_new.xpath('//Segment').each do |noun|
      hash_noun = Hash.from_xml(noun.to_s).deep_transform_keys{ |key| key.to_s.camelize(:lower) }
      floc_change << process_sync_noun(hash_noun.with_indifferent_access)
      debugger
    end
    debugger
    return floc_change
  end

  def process_sync_noun(noun)
    segment_noun = noun[:segment]
    segment_noun[:childComponent].each do |child_component|
      process_sync_child_components(child_component, segment_noun[:uUID])
    end
    Rails.logger.debug "\n Functional Location  successfully created"
    return "sync_complete"
    rescue StandardError => e
      Rails.logger.error("\n Functional Location COULD NOT be created #{e}")
  end

  def process_sync_child_components(segment, parent_component='')

    # Safe check - if not present, the value is nil and nil.each throws an exception
    if segment[:child][:childComponent].present?
      segment[:child][:childComponent].each do |component|
        process_sync_child_components(component, segment[:child][:uUID])
        bds = BreakDownStructure.find_or_initialize_by uuid: SecureRandom.uuid
        bds.to = component[:child][:uUID]
        bds.from = parent_component
        bds.save!
        floc = FunctionalLocation.find_or_initialize_by uuid: component[:child][:uUID]
        floc.assign_values_to_floc_from_sync_segments(component[:child], bds)
        floc.save!
      end
    end
  end

end
