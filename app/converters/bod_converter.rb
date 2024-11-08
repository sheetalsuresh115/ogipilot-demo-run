module BodConverter
  include SyncActualEventsBodConverter
  def convert_bod_to_equipment_object
    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncActualEvents.xml.erb'))
    xml_hash = Hash.from_xml(xml_doc.to_s).deep_transform_keys { |key| xml_to_hash_key_transformer(key) }
    equipment_obj = convert_sync_actual_events_bod_to_equipment_object(xml_hash)
  end

  def xml_to_hash_key_transformer(key)
  end

end
