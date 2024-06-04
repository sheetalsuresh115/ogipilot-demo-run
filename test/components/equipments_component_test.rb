# frozen_string_literal: true

require "test_helper"

class EquipmentsComponentTest < ViewComponent::TestCase
  def test_component_renders_page
    assert_equal(
      %(<span>Hello, components!</span>),
      render_inline(EquipmentsComponent.new(message: "Hello, components!")).css("span").to_html
    )
    assert_text("Hello, components!")
  end
end
