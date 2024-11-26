module BodConverter

  def read_sync_bod(bod, x_path, opts={})
    if bod.class == Nokogiri::XML::Document
      bod_new = bod
    else
      bod_new = Nokogiri::XML(bod)
    end
    bod_new.remove_namespaces!

    bod_new.xpath(x_path).each do |noun|
      hash_noun = Hash.from_xml(noun.to_s).deep_transform_keys{ |key| key.to_s.camelize(:lower) }
      process_sync_noun(hash_noun.with_indifferent_access)
    end

  end

  # As discussed, creating this as a backup for missing flocs
  # comments are added to inspect further.
  def create_missing_floc(floc_info, noun_value)
    floc = FunctionalLocation.new(uuid: floc_info[:uUID])
    floc.create_functional_location_with_minimal_info(floc_info, "Floc Missing: Floc added from #{noun_value}")
    floc.save!
    return floc
  end

end
