module SyncBreakDownStructuresConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      floc = FunctionalLocation.find_by uuid: noun.dig("breakdownStructure","networkForSegment","segment","uUID")
      unless floc.present?
        floc = create_missing_floc(noun.dig("breakdownStructure","networkForSegment","segment"), "SyncBreakDownStructures")
      end

      noun.dig("breakdownStructure","connection").each do |connection|

        bds = BreakDownStructure.find_by(uuid: noun.dig("breakdownStructure","uUID"), from_uuid: connection.dig("from","uUID"), to_uuid: connection.dig("to","uUID"))
        unless bds.present?
          bds = BreakDownStructure.create(uuid: noun.dig("breakdownStructure","uUID"), from_uuid: connection.dig("from","uUID"), to_uuid: connection.dig("to","uUID"),
            short_name: noun.dig("breakdownStructure","shortName"), functional_location: floc)
        end

      end
      Rails.logger.debug "\n Break Down Structures successfully added."

    rescue StandardError => e
      Rails.logger.error("\n Break Down Structure COULD NOT be added - #{e}")
    end
  end


end
