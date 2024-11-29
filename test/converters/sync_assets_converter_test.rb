require "test_helper"

class SyncAssetsConverterTest < ActiveSupport::TestCase
include SyncAssetsConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_asset_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync assets and create equipment" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_asset_path))
    read_sync_bod(xml_doc, "//Asset")

    xml_doc.xpath("//Asset/UUID").each do |noun|
      asset = Equipment.find_by uuid: noun.text.strip
      assert asset.present?
    end

  end

end
