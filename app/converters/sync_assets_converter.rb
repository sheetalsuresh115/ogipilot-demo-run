module SyncAssetsConverter
  include BodConverter
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
