class MeasurementsController < ApplicationController
  def create
    params[:equipment] = Equipment.find(measurement_params[:equipment_id])
    @measurement = Measurement.new(measurement_params)
    @measurement.save
  end

  private
  def measurement_params
    params.require(:measurement).permit(:equipment_id, :time_stamp, :data, :equipment)
  end
end
