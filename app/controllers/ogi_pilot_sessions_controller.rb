require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class OgiPilotSessionsController < ApplicationController

  def new
    @session = OgiPilotSession.new
    logger.debug "NEW session initialized: #{@session.inspect}"
    render(SessionCreationComponent.new(session: @session))
  end

  def create
    @session  = OgiPilotSession.new(ogi_pilot_session_params)
    if @session.save
      redirect_to ogi_pilot_sessions_path, notice: 'Session was successfully created.'
    else
      render turbo_stream: turbo_stream.replace(
        'session_form',
        renderable: SessionCreationComponent.new(session: @session)
      ), status: :unprocessable_entity
    end
  end

  def index
    @sessions = OgiPilotSession.all
  end

  def edit
    @session = OgiPilotSession.find(params[:id])
    render(SessionCreationComponent.new(session: @session))
  end

  def update
    @session = OgiPilotSession.find(params[:id])

    if @session.update(ogi_pilot_session_params)
      redirect_to ogi_pilot_sessions_path, notice: 'Session was successfully updated.'
    else
      render SessionCreationComponent.new(session: @session), status: :unprocessable_entity
    end
  end

  def destroy
    @session = OgiPilotSession.find(params[:id])
    if @session.destroy
      flash[:notice] = "Session was successfully deleted."
    else
      flash[:alert] = "Failed to delete the equipment. There might be dependencies preventing the deletion."
    end
    redirect_to ogi_pilot_sessions_path
  end

  def open
    @session = OgiPilotSession.find(params[:id])
    begin
      # Open session: respond with session id
      @session.open_session
      PubSubSchedulerJob.perform_later(topic: [@session.topic], provider_session_id: @session.provider_session_id,
        consumer_session_id: @session.consumer_session_id, confirmation_session_id:"")

      redirect_to ogi_pilot_sessions_path
      rescue IsbmAdaptor::IsbmFault => e
        ## TODO: make the errors parse the response
        logger.debug "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
    end
  end

  def close
    begin
      session = OgiPilotSession.find(params[:id])
      session.close_session

      logger.debug "Session closed successfully"
      redirect_to ogi_pilot_sessions_path
    rescue IsbmAdaptor::IsbmFault => e
      logger.debug "Exception when calling PublicationConsumerApi->close_session: #{e} => #{e.response_body}"
    end
  end

  private
    def ogi_pilot_session_params
      params.require(:ogi_pilot_session).permit(:end_point, :channel, :topic, :message_type, :user_name, :password)
    end
end
