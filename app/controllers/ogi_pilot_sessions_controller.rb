require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class OgiPilotSessionsController < ApplicationController

  def new
    session = OgiPilotSession.new
    logger.debug "NEW session initialized: #{session.inspect}"
    render(SessionCreationComponent.new(session: session))
  end

  def create
    session  = OgiPilotSession.new(ogi_pilot_session_params)
    if session.save
      redirect_to ogi_pilot_sessions_path
    else
      render turbo_stream: turbo_stream.replace(
        'session_form',
        renderable: SessionCreationComponent.new(session: session)
      ), status: :unprocessable_entity
    end
  end

  def index
    @sessions = OgiPilotSession.all
  end

  def edit
    session = OgiPilotSession.find(params[:id])
    render(SessionCreationComponent.new(session: session))
  end

  def update
    session = OgiPilotSession.find(params[:id])

    if session.update(ogi_pilot_session_params)
      redirect_to ogi_pilot_sessions_path
    else
      render SessionCreationComponent.new(session: session), status: :unprocessable_entity
    end
  end

  def destroy
    session = OgiPilotSession.find(params[:id])
    if session.destroy
      flash[:notice] = "Session was successfully deleted."
    else
      flash[:alert] = "Failed to delete the session. There might be dependencies preventing the deletion."
    end
    redirect_to ogi_pilot_sessions_path
  end

  def open
    session = OgiPilotSession.find(params[:id])
    session.open_session
    redirect_to ogi_pilot_sessions_path
  end

  def close
    session = OgiPilotSession.find(params[:id])
    session.close_session
    # flash[:alert] = session.validation_messages
    # response.set_header("Turbo-Frame", "_top")

    # Flash messages are not working because Turbo reloads partials and not whole page.
    # see_other below triggers a full reload but since the form is a Turbo-frame - the request header contains the turboFrame
    # Tried resetting the response header to turbo-frame _top ...
    # taking more time than expected, will get back to fixing flash messages at a later point.


    redirect_to ogi_pilot_sessions_path, status: :see_other
  end

  private
    def ogi_pilot_session_params
      params.require(:ogi_pilot_session).permit(:end_point, :channel, :topic, :message_type, :user_name, :password)
    end
end
