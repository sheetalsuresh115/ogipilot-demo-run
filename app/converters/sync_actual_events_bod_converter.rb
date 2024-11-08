module SyncActualEventsBodConverter

  def sync_actual_events_bod_converter()
    # let(:xml_doc) { Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncActualEvents.xml.erb')) }
    # let(:xml_hash) { Hash.from_xml(xml_doc.to_s).deep_transform_keys { |key| BOD.xml_to_hash_key_transformer(key) } }
    return xml_hash
  end

  def convert_sync_actual_events_bod_to_equipment_object()
    rfw = BOD::RequestsForWork.read_process_bod(xml_hash)
  end

end
