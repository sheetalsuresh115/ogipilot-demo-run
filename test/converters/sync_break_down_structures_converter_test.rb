require "test_helper"

class SyncBreakDownStructuresConverterTest < ActiveSupport::TestCase
include SyncBreakDownStructuresConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_break_down_structures_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync asset segment events and create relation" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_break_down_structures_path))
    assert_no_error_reported{ read_sync_bod(xml_doc, "//BreakdownStructure") }
  end

end
