require "test_helper"

class SyncBreakDownStructuresConverterTest < ActiveSupport::TestCase
include SyncBreakDownStructuresConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_break_down_structures_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync break down structure and create bds" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_break_down_structures_path))
    read_sync_bod(xml_doc, "//BreakdownStructure")

    xml_doc.xpath("//BreakdownStructure/Connection").each do |noun|
      bds = BreakDownStructure.find_by(uuid: noun.xpath("//BreakdownStructure/UUID").text.strip,
        from_uuid: noun.xpath("From/UUID")[0].text.strip,
        to_uuid: noun.xpath("To/UUID")[0].text.strip)
      assert bds.present?
    end
  end

end
