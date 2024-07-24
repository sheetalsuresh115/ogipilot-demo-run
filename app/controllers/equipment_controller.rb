# frozen_string_literal: true
require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class EquipmentController < ApplicationController

  def new
    @equipment = Equipment.new
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      redirect_to @equipment, notice: 'Equipment was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @equipments = Equipment.all
    Typhoeus::Config.verbose = true
    IsbmRestAdaptor.configure do |conf|
      conf.host = 'isbm.lab.oiiecosystem.net'
      conf.scheme = 'https'
      conf.base_path = '/rest'
      # conf.debugging = true
      conf.ssl_ca_cert = "C:/Program Files/curl/curl-ca-bundle.crt"
    end

    # @messages = Array.new()
    @session = OgiPilotSession.find_by topic: "BaseLineRisk"
    if @session.consumer_session_id.present?
      subscribe_client = IsbmRestAdaptor::ConsumerPublication.new
      # while message = subscribe_client.read_publication(@session.consumer_session_id) do
      #   @messages.push(message)
      #   puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
      # end

      @messages = subscribe_client.read_publication(@session.consumer_session_id)
    else
      redirect_to equipments_path, alert: 'Please open a valid session!'
    end

    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body) if e.response_body.present?
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
  end

  def edit
    @equipment = Equipment.find(params[:id])
    render EquipmentCreationComponent.new(equipment: @equipment)
  end

  def update
    @equipment = Equipment.find(params[:id])

    if @equipment.update(equipment_params)
      redirect_to equipments_path, notice: 'Equipment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def equipment_params
      params.require(:equipment).permit(:uuid, :id_in_source, :functional_location_id, :segment_uuid, :site_id, :short_name,
        :properties, :bod_content)
    end

end
