class RiskDashboardsController < ApplicationController

  def measurements
    # Using ActionCables, data will be live streamed.
    measurements = Measurement.last(10)
    timestamp_labels = []
    datasets = []
    measurements.each do |measurement_obj|
      timestamp_labels.push(measurement_obj.time_stamp)
      datasets.push(measurement_obj.data)
    end
    @timestamps = timestamp_labels
    @vibrations = datasets
  end

  def active_standby
    @equipments = Equipment.all
  end

  def baseline_risk
    begin
      session = OgiPilotSession.find_by topic: "BaseLineRisk"
      if session && session.provider_session_exists
        session.post_base_line_risk_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue StandardError, IsbmAdaptor::ChannelFault, IsbmAdaptor::SessionFault, IsbmAdaptor::ParameterFault,
      IsbmAdaptor::IsbmFault => e
      logger.debug " Exception during risk #{e}"
    end
  end

  def possible_failure
    begin
      session = OgiPilotSession.find_by topic: "PossibleFailure"
      if session && session.provider_session_exists
        session.post_possible_failure_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue StandardError, IsbmAdaptor::ChannelFault, IsbmAdaptor::SessionFault, IsbmAdaptor::ParameterFault,
      IsbmAdaptor::IsbmFault => e
      logger.debug " Exception during failure #{e}"
    end
  end

  def failure
    begin
      session = OgiPilotSession.find_by topic: "Failure"
      if session && session.provider_session_exists
        session.post_failure_message
      else
        flash[:alert] = "Please open a valid session!"
      end
      redirect_back(fallback_location: root_path)

    rescue StandardError, IsbmAdaptor::ChannelFault, IsbmAdaptor::SessionFault, IsbmAdaptor::ParameterFault,
      IsbmAdaptor::IsbmFault => e
      logger.debug " Exception during failure #{e}"
    end
  end

  def segment
    session = OgiPilotSession.find_by topic: "SyncSegments"
    post_message(session)
  end

  def asset
    session = OgiPilotSession.find_by topic: "SyncAssets"
    post_message(session)
  end

  def asset_segment_event
    session = OgiPilotSession.find_by topic: "SyncAssetSegmentEvents"
    post_message(session)
  end

  def break_down_structure
    session = OgiPilotSession.find_by topic: "SyncBreakDownStructures"
    post_message(session)
  end

  def actual_event
    session = OgiPilotSession.find_by topic: "SyncActualEvents"
    post_message(session)
  end

  def post_message(session)

    if session && session.provider_session_exists
      data_path = ""
      data_path = Settings.data.sync_segment_path if session.topic == "SyncSegments"
      data_path = Settings.data.sync_asset_path if session.topic == "SyncAssets"
      data_path = Settings.data.sync_asset_segment_events_path if session.topic == "SyncAssetSegmentEvents"
      data_path = Settings.data.sync_break_down_structures_path if session.topic == "SyncBreakDownStructures"
      data_path = Settings.data.sync_actual_events_path if session.topic == "SyncActualEvents"

      session.post_sync_message(data_path)
    else
      flash[:alert] = "Please open a valid session!"
    end
    redirect_back(fallback_location: root_path)
    rescue StandardError, IsbmAdaptor::ChannelFault, IsbmAdaptor::SessionFault, IsbmAdaptor::ParameterFault,
      IsbmAdaptor::IsbmFault => e
      logger.debug " Exception during publishing syncSegment #{e}"
  end

end
