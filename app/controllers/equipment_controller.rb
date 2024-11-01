# frozen_string_literal: true
require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class EquipmentController < ApplicationController
  before_action :validate_source

  def new
    # Alarms and Break Down Structures displays the same list of equipments.
    # Hence, source here indicates the origin of this request.
    # After the object gets saved, it gets redirected to its source based on this parameter.
    @equipment = Equipment.new
    @source = params[:source]
    render(EquipmentCreationComponent.new(equipment: @equipment, source: @source))
  end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.save
      redirect_to_source
    else
      render turbo_stream: turbo_stream.replace(
        'equipment_form',
        renderable: EquipmentCreationComponent.new(equipment: @equipment, source: params[:source])
      ), status: :unprocessable_entity
    end
  end

  def index
    # All assets are grouped by functional location.
    @equipments = Equipment.all.group_by(&:functional_location_id)
    @source_dict = {
      source: params[:source] || "BreakDownStructures",
      status: params[:source] == "BreakDownStructures" ? "Status" : "Alarm Status",
      title: params[:source] == "BreakDownStructures" ? "Break Down Structures" : "Alarms"
    }
  end

  def edit
    @equipment = Equipment.find(params[:id])
    @source = params[:source]
    render(EquipmentCreationComponent.new(equipment: @equipment, source: @source))
  end

  def update
    @equipment = Equipment.find(params[:id])

    if @equipment.update(equipment_params)
      redirect_to_source
    else
      render turbo_stream: turbo_stream.replace(
        'equipment_form',
        renderable: EquipmentCreationComponent.new(equipment: @equipment, source: params[:source])
      ), status: :unprocessable_entity
    end
  end

  def destroy
    @equipment = Equipment.find(params[:id])
    @equipment.destroy
    # Yet to fix the Flash message for Turbo. ( Use see_other)
    # if @equipment.destroy
    #   flash[:notice] = "Equipment was successfully deleted."
    # else
    #   flash[:alert] = "Failed to delete the equipment. There might be dependencies preventing the deletion."
    # end
    redirect_to_source
  end

  def redirect_to_source
    if params[:source] == "BreakDownStructures"
      redirect_to equipment_index_path(source: "BreakDownStructures")
    elsif params[:source] == "Alarms"
      redirect_to equipment_index_path(source: "Alarms")
    end
  end

  def validate_source
    valid_sources = ["BreakDownStructures", "Alarms"]

    unless valid_sources.include?(params[:source])
      flash[:alert] = "Invalid source provided"
      redirect_to root_path
    end
  end

  private
    def equipment_params
      params.require(:equipment).permit(:uuid, :id_in_source, :functional_location_id, :segment_uuid, :site_id, :short_name,
        :properties, :bod_content, :status_id, :alarm_id, :is_active)
    end

end
