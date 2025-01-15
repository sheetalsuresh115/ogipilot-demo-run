# frozen_string_literal: true

require "test_helper"

class SyncSegmentsConverterTest < ActiveSupport::TestCase
include SyncSegmentsConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_segment_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync segments and create functional location" do

    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_segment_path))
    read_sync_bod(xml_doc, "//Segment")
    xml_doc.xpath("//Segment").each do |noun|
      floc = FunctionalLocation.find_by uuid: noun.xpath("//Segment/UUID").text.strip
      assert floc.present?
    end

  end

end
