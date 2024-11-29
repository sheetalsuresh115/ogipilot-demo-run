# frozen_string_literal: true

class SessionCreationComponent < ViewComponent::Base

  def initialize(session: )
    @session = session
  end
end
