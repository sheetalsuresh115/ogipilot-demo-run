# frozen_string_literal: true

require "test_helper"

class SyncSegmentsConverterTest < ActiveSupport::TestCase
include SyncSegmentsConverter
  def test_read_bod_contents
    # let expected_bod BodConverter::SyncActualEventsBodConverter
    # assert_equal(
    #   %(<span>Hello, components!</span>),
    #   render_inline(ActiveComponentsComponent.new(message: "Hello, components!")).css("span").to_html
    # )
  end

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncSegments.xml.erb'))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync segments and create functional location" do

    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncSegments.xml.erb'))
    floc_change, all_fields = read_sync_bod(xml_doc)
    debugger
    assert(floc_change, "sync_complete")
  end

end
