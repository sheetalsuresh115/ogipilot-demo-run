module SyncAssetSegmentEventsConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      asset = Equipment.find_by uuid: noun[:assetSegmentEvent][:asset][:uUID]
      floc = FunctionalLocation.find_by uuid: noun[:assetSegmentEvent][:segment][:uUID]
      if asset.present?
        asset.functional_location =  floc.present? ? floc : nil
        asset.save!
      else
        raise StandardError.new "Asset does not exist in system."
      end
      Rails.logger.debug "\n Asset Segment Relation successfully added"

    rescue StandardError => e
      Rails.logger.error("\n Asset Segment Relation COULD NOT be added - #{e}")
    end
  end

end
