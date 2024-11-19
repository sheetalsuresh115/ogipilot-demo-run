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
    assert_no_error_reported{ read_sync_bod(xml_doc, "//AssetSegmentEvents") }
  end

end
