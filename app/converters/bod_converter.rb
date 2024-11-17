module BodConverter

  def read_sync_bod(bod, x_path, opts={})
    bod_change = []
    if bod.class == Nokogiri::XML::Document
      bod_new = bod
    else
      bod_new = Nokogiri::XML(bod)
    end
    bod_new.remove_namespaces!

    bod_new.xpath(x_path).each do |noun|
      hash_noun = Hash.from_xml(noun.to_s).deep_transform_keys{ |key| key.to_s.camelize(:lower) }
      bod_change << process_sync_noun(hash_noun.with_indifferent_access)
    end
    return bod_change

    rescue StandardError => e
      Rails.logger.error("\n Asset COULD NOT be created #{e}")
  end

end
