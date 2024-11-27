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

  test "read sync actual events and create relation" do

    xml_doc = Nokogiri::XML(File.open(Settings.data.sync_actual_events_path))
    assert_no_error_reported{ read_sync_bod(xml_doc, "//ActualEvent") }
  end

end
