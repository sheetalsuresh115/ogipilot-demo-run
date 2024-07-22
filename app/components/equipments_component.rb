# frozen_string_literal: true
require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class EquipmentsComponent < ViewComponent::Base

  def initialize(equipments:)
    @equipments = equipments
    # @messages = Array.new()
    @session = OgiPilotSession.find_by topic: "BaseLineRisk"
    if @session.consumer_session_id.is_present?:
      subscribe_client = IsbmRestAdaptor::ConsumerPublication.new
      # while message = subscribe_client.read_publication(@session.consumer_session_id) do
      #   debugger
      #   @messages.push(message)
      #   puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
      # end

      @messages = subscribe_client.read_publication(@session.consumer_session_id)
    end

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body) if e.response_body.present?
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
  end

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      redirect_to load_equipment_component_path, notice: 'Equipment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

end
