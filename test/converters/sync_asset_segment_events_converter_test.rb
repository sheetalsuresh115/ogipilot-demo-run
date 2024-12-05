require "test_helper"

class SyncAssetSegmentEventsConverterTest < ActiveSupport::TestCase
include SyncAssetSegmentEventsConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_asset_segment_events_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync asset segment events and create relation" do

    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_asset_segment_events_path))
    read_sync_bod(xml_doc, "//AssetSegmentEvent")
    xml_doc.xpath("//AssetSegmentEvent").each do |noun|
      asset = Equipment.find_by( uuid: noun.xpath("Asset/UUID").text.strip)
      floc = FunctionalLocation.find_by uuid: noun.xpath("Segment/UUID").text.strip
      assert asset.functional_location == floc
    end

  end

end
