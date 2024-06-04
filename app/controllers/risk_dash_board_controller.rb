class RiskDashBoardController < ApplicationController
  def index
    @equipments = Equipment.all
  end

  def show
    @equipments = Equipment.all
  end

  def load_equipment_component
    @equipments = Equipment.all
  end

  def load_measurements_component
    @measurements = Equipment.all
  end

  def load_alarms_component
    @alarms = Equipment.all
  end

  def load_active_component
    @active = Equipment.all
  end

  def load_new_session_management_component
    @sessions = Session.all
  end
end
