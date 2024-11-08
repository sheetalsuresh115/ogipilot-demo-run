# frozen_string_literal: true

require "test_helper"

class SyncActualEventsBodConverterTest < ActiveSupport::TestCase
include BodConverter
  def test_read_bod_contents
    # let expected_bod BodConverter::SyncActualEventsBodConverter
    # assert_equal(
    #   %(<span>Hello, components!</span>),
    #   render_inline(ActiveComponentsComponent.new(message: "Hello, components!")).css("span").to_html
    # )
  end

  test "read from xml file" do
    xml_doc = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncActualEvents.xml.erb'))
    xml_hash = Hash.from_xml(xml_doc.to_s).deep_transform_keys { |key| xml_to_hash_key_transformer(key) }
    assert_not xml_doc.nil?
    assert_not xml_hash.nil?
  end

  test "extract from xml" do
    bod = Nokogiri::XML(File.open('C:\Users\sureshs\Visual Studio\Visual Studio Code Repo\ogipilot-demo-run\ogipilot-demo-run\data\SyncActualEvents.xml.erb'))
    # bod = Hash.from_xml(xml_doc.to_s)
    if bod.class == Nokogiri::XML::Document
      bod_new = bod
    else
      bod_new = Nokogiri::XML(bod)
    end
    bod_new.remove_namespaces!

    # collect fields and values
    bod_new.xpath('//RequestForAsset').each do |path|
      create_fields << extract_all_fields_and_values(bod_new, path)
      hash_noun = Hash.from_xml(path.to_s).deep_transform_keys{ |key| key.to_s.camelize(:lower) }
      asset_create << process_process_noun(hash_noun.with_indifferent_access, create_fields)
    end

    return asset_create, create_fields
  end

end
