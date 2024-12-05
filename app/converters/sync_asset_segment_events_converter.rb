module SyncAssetSegmentEventsConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      asset = Equipment.find_by uuid: noun.dig("assetSegmentEvent","asset","uUID")
      floc = FunctionalLocation.find_by uuid: noun.dig("assetSegmentEvent","segment","uUID")

      unless floc.present?
        floc = create_missing_floc(noun.dig("assetSegmentEvent","segment"), "SyncAssetSegmentEvents")
      end

      unless asset.present?
        asset = create_missing_asset(noun.dig("assetSegmentEvent","asset"), "SyncAssetSegmentEvents")
      end

      asset.functional_location =  floc
      asset.save!

      Rails.logger.debug "\n Asset Segment Relation successfully added"

    rescue StandardError => e
      Rails.logger.error("\n Asset Segment Relation COULD NOT be added - #{e}")
    end
  end

end
