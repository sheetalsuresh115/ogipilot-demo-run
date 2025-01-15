require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class OgiPilotSessionsController < ApplicationController

  $publish_client = IsbmRestAdaptor::ProviderPublication.new
  $subscribe_client = IsbmRestAdaptor::ConsumerPublication.new

  def new
    @session = OgiPilotSession.new
    logger.debug "NEW session initialized: #{@session.inspect}"
  end

  def create
    @session = OgiPilotSession.new(ogi_pilot_session_params)
    if @session.save
      redirect_to ogi_pilot_sessions_path, notice: 'Session was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @sessions = OgiPilotSession.all
    Typhoeus::Config.verbose = true
    IsbmRestAdaptor.configure do |conf|
      conf.host = 'isbm.lab.oiiecosystem.net'
      conf.scheme = 'https'
      conf.base_path = '/rest'
      # conf.debugging = true
      conf.ssl_ca_cert = "C:/Program Files/curl/curl-ca-bundle.crt"
    end
  end

  def edit
    @session = OgiPilotSession.find(params[:id])
    render SessionCreationComponent.new(session: @session)
  end

  def update
    @session = OgiPilotSession.find(params[:id])

    if @session.update(ogi_pilot_session_params)
      redirect_to ogi_pilot_sessions_path, notice: 'Session was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @session = OgiPilotSession.find(params[:id])
    @session.destroy
    redirect_to ogi_pilot_sessions_path, notice: 'Session was successfully deleted.'
  end

  def open
    @session = OgiPilotSession.find(params[:id])

    begin
      # Open session: respond with session id
      @session.consumer_session_id = $subscribe_client.open_session(@session.channel, [@session.topic])
      puts "Subscription session opened successfully: #{response}"

      @session.provider_session_id = $publish_client.open_session(@session.channel)
      puts "Publication Session opened successfully: #{response}"

      @session.save
      PubSubSchedulerJob.perform_later(topic: [@session.topic], provider_session_id: @session.provider_session_id,
        consumer_session_id: @session.consumer_session_id, confirmation_session_id:"")

      redirect_to ogi_pilot_sessions_path, notice: 'Session opened successfully.'
      rescue IsbmAdaptor::IsbmFault => e
        ## TODO: make the errors parse the response
        puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
    end
  end

  def close
    @session = OgiPilotSession.find(params[:id])
    puts "\n*** Closing subscription session on open channel"
    begin
      $subscribe_client.close_session(@session.consumer_session_id)
      $publish_client.close_session(@session.provider_session_id)
      @session.consumer_session_id = nil
      @session.provider_session_id = nil
      @session.save
      puts "Session closed successfully"
      redirect_to ogi_pilot_sessions_path, notice: 'Session closed successfully'
    rescue IsbmAdaptor::IsbmFault => e
      puts "Exception when calling PublicationConsumerApi->close_session: #{e} => #{e.response_body}"
    end

  end

  private
    def ogi_pilot_session_params
      params.require(:ogi_pilot_session).permit(:end_point, :channel, :topic, :message_type)
    end
end
