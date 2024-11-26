module SyncBreakDownStructuresConverter
  include BodConverter

  def process_sync_noun(noun)
    begin
      floc = FunctionalLocation.find_by uuid: noun[:breakdownStructure][:networkForSegment][:segment][:uUID]
      unless floc.present?
        floc = create_missing_floc(noun[:breakdownStructure][:networkForSegment][:segment], "SyncBreakDownStructures")
      end

      noun[:breakdownStructure][:connection].each do |connection|

        bds = BreakDownStructure.find_by(uuid: noun[:breakdownStructure][:uUID], from: connection[:from][:uUID], to: connection[:to][:uUID])
        unless bds.present?
          bds = BreakDownStructure.create(uuid: noun[:breakdownStructure][:uUID], from: connection[:from][:uUID], to: connection[:to][:uUID],
            short_name: noun[:breakdownStructure][:shortName], functional_location: floc)
        end

      end
      Rails.logger.debug "\n Break Down Structures successfully added."

    rescue StandardError => e
      Rails.logger.error("\n Break Down Structure COULD NOT be added - #{e}")
    end
  end


end
