# frozen_string_literal: true
require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class EquipmentController < ApplicationController

  def new
    @equipment = Equipment.new
    @source = params[:source]
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      redirect_to_source
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    Typhoeus::Config.verbose = true
    IsbmRestAdaptor.configure do |conf|
      conf.host = 'isbm.lab.oiiecosystem.net'
      conf.scheme = 'https'
      conf.base_path = '/rest'
      # conf.debugging = true
      conf.ssl_ca_cert = "C:/Program Files/curl/curl-ca-bundle.crt"
    end
    @source = params[:source] || "BreakDownStructures"
    @equipments = Equipment.all.group_by(&:functional_location_id)
    rescue IsbmAdaptor::IsbmFault => e
      fault_message = extract_fault_message(e.response_body) if e.response_body.present?
      return check_session_fault_message_not_found(fault_message) if e.code == 404
      handle_session_access_api_error(e.code, fault_message)
  end

  def edit
    @equipment = Equipment.find(params[:id])
    render EquipmentCreationComponent.new(equipment: @equipment, source: params[:source])
  end

  def update
    @equipment = Equipment.find(params[:id])

    if @equipment.update(equipment_params)
      redirect_to_source
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy

    redirect_to_source
  end

  def redirect_to_source
    if params[:source] == "BreakDownStructures"
      redirect_to equipment_index_path(source: "BreakDownStructures")
    elsif params[:source] == "Alarms"
      redirect_to equipment_index_path(source: "Alarms")
    end
  end

  # def computeStatus(equipments)
  #   # @equipment = Equipment.find(params[:id])
  #   equipments.each_with_index do |(floc, records), index|
  #     records.each do |equipment|
  #       if equipment.status_id == LifeCycleStatusHelper.NORMAL
  #         @status_type = "alert-success"
  #         @status = "NORMAL"
  #       elsif equipment.status_id == LifeCycleStatusHelper.WARNING
  #         @status_type = "alert-warning"
  #         @status = "WARNING"
  #       elsif equipment.status_id == LifeCycleStatusHelper.ALERT
  #         @status_type = "alert-info"
  #         @status = "ALERT"
  #       elsif equipment.status_id == LifeCycleStatusHelper.DANGER
  #         @status_type = "alert-danger"
  #         @status = "DANGER"
  #       elsif equipment.status_id == LifeCycleStatusHelper.UNDETERMINED
  #         @status_type = "alert-secondary"
  #         @status = "UNDETERMINED"
  #       end
  #     end
  #   end

  #   equipments.map do |equipment|
  #     {
  #       equipment: equipment,
  #       status_type: @status_type,
  #       status: @status
  #     }
  #   end

  #   redirect_to equipment_index_path, notice: 'Equipment was successfully deleted.'
  # end

  def check_for_risk
    @messages = Array.new()
    @session = OgiPilotSession.find_by topic: "BaseLineRisk"
    if @session.consumer_session_id.present?
      subscribe_client = IsbmRestAdaptor::ConsumerPublication.new
      while message = subscribe_client.read_publication(@session.consumer_session_id) do
        @messages.push(message)
        subscribe_client.remove_publication(@session.consumer_session_id)
        puts "Read message #{message.id} from topics #{message.topics} of type #{message.media_type}:\n#{message.content}"
        $break_down_structure_notification -= 1
        $alarms_notification -= 1
        $measurements_notification -= 1
      end

      debugger
      if @messages
        @messages.each do |message|
          #TBD - Logic to read data from a syncBod and create the bodObject

          @update_equipment = Equipment.find_by(uuid: message.content[:uuid])
          if @update_equipment
            @update_equipment.status_id = message.content[:status_id]
            @update_equipment.alarm_id = message.content[:alarm_id]
            @update_equipment.save
          end
        end
      end
    end
    redirect_to_source
  end

  private
    def equipment_params
      params.require(:equipment).permit(:uuid, :id_in_source, :functional_location_id, :segment_uuid, :site_id, :short_name,
        :properties, :bod_content, :status_id, :alarm_id)
    end

end
