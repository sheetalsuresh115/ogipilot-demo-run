module SyncAssetsConverter

  def read_sync_bod(bod, opts={})
    asset_change = []
    if bod.class == Nokogiri::XML::Document
      bod_new = bod
    else
      bod_new = Nokogiri::XML(bod)
    end

    bod_new.remove_namespaces!
    # process noun with collected update fields and values
    bod_new.xpath('//Asset').each do |noun|
      hash_noun = Hash.from_xml(noun.to_s).deep_transform_keys{ |key| key.to_s.camelize(:lower) }
      asset_change << process_sync_noun(hash_noun.with_indifferent_access)
    end
    return asset_change

    rescue StandardError => e
      Rails.logger.error("\n Asset COULD NOT be created #{e}")
  end

  def process_sync_noun(noun)
    asset_noun = noun[:asset]
    asset = Equipment.find_or_initialize_by uuid: asset_noun[:uUID]
    asset.assign_values_to_asset_from_sync_assets(asset_noun, nil)
    asset.save!
    Rails.logger.debug "\n Asset successfully created"
    return "sync_complete"
    rescue StandardError => e
      Rails.logger.error("\n Asset COULD NOT be created #{e}")
  end

end
