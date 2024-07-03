require 'securerandom'
require 'isbm2_adaptor_rest'
require 'isbm_adaptor_common'

class SessionsController < ApplicationController

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(session_params)
    if @session.save
      redirect_to sessions_path, notice: 'Session was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @sessions = Session.all
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
    @session = Session.find(params[:id])
    render SessionCreationComponent.new(session: @session)
  end

  def update
    @session = Session.find(params[:id])

    if @session.update(session_params)
      redirect_to sessions_path, notice: 'Session was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def session_management
    @session = Session.all
  end

  def destroy
    @session = Session.find(params[:id])
    @session.destroy
    redirect_to sessions_path, notice: 'Session was successfully deleted.'
  end

  def open
    @session = Session.find(params[:id])
    subscription_service = IsbmRestAdaptor::ConsumerPublicationServiceApi.new
    subscriber_session = IsbmRestAdaptor::Session.new(topics: [@session.topic])
    debugger
    begin
      # Open session: respond with session id
      response = subscription_service.open_subscription_session(@session.channel, session: subscriber_session)
      puts "Session opened successfully: #{response}"
      subscriber_session.session_id = response.session_id
      @session.session_id = subscriber_session.session_id
      @session.save
    rescue IsbmRestAdaptor::ApiError => e
      ## TODO: make the errors parse the response
      puts "Exception when calling PublicationConsumerApi->open_subscription_session: #{e} => #{e.response_body}"
    end

    # publication_session = nil
    # puts "\n*** Opening publication session"
    # begin
    #   # Open session: respond with session id
    #   response = publication_service.open_publication_session(open_channel.uri)
    #   puts "Session opened successfully: #{response}"
    #   publication_session = response
    # rescue IsbmRestAdaptor::ApiError => e
    #   ## TODO: make the errors parse the response
    #   puts "Exception when calling PublicationProviderApi->open_publication_session: #{e} => #{e.response_body}"
    # end

  end

  def close
    debugger
    subscription_service = IsbmRestAdaptor::ConsumerPublicationServiceApi.new
    @session = Session.find(params[:id])
    puts "\n*** Closing subscription session on open channel"
    begin
      subscription_service.close_session(@session.session_id)
      @session.session_id = nil
      debugger
      puts "Session closed successfully"
    rescue IsbmRestAdaptor::ApiError => e
      puts "Exception when calling PublicationConsumerApi->close_session: #{e} => #{e.response_body}"
    end

  end

  private
    def session_params
      params.require(:session).permit(:end_point, :channel, :topic, :message_type)
    end
end
