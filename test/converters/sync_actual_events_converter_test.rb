# frozen_string_literal: true

require "test_helper"

class SyncActualEventsConverterTest < ActiveSupport::TestCase
include SyncActualEventsConverter

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_actual_events_path))
    xml_hash = Hash.from_xml(xml_doc.to_s)
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "read sync actual events which contains risk information update" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_actual_events_path))
    read_sync_bod(xml_doc, "//ActualEvent")

    xml_doc.xpath("//ActualEvent").each do |noun|
      floc = FunctionalLocation.find_by uuid: noun.xpath("Entity/UUID").text.strip
      ac_added = ActualEvent.find_by(uuid: noun.xpath("UUID").text.strip,
        group_uuid: noun.xpath("AttributeSetForEntity/AttributeSet/Group/UUID").text.strip,
        attribute_type: noun.xpath("Type/UUID").text.strip, functional_location: floc)

      assert ac_added.present?
      assert ac_added.value.present?
    end


  end

  test "read sync actual events which contains abnormal frequencies" do
    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_actual_events_abnormal_path))
    read_sync_bod(xml_doc, "//ActualEvent")

    floc = FunctionalLocation.find_by uuid: xml_doc.xpath("//ActualEvent/Entity/UUID").text.strip
    ac_added = ActualEvent.find_by(uuid: xml_doc.xpath("//ActualEvent/UUID").text.strip, group_uuid: nil,
    attribute_type:  xml_doc.xpath("//ActualEvent/Type/UUID").text.strip, value: '', uom: '', functional_location: floc)

    assert ac_added.present?
  end


end
