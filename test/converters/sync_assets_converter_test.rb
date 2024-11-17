require "test_helper"

class SyncAssetsConverterTest < ActiveSupport::TestCase
include SyncAssetsConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncAssets.xml.erb'))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync segments and create functional location" do
    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncAssets.xml.erb'))
    floc_change, all_fields = read_sync_bod(xml_doc)
    assert(floc_change, "sync_complete")
  end

end
