# app.rb
require 'sinatra'
require 'erubis'
require 'aws-sdk'
require 'securerandom'

require_relative 'environment'
require_relative 'models'

class RsvpApp < Sinatra::Base
  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    require 'dotenv'
    Dotenv.load
  end

  configure :production do
    require 'newrelic_rpm'
  end

  # escapes html in <%= %>, but not in <%== %>
  set :erb, :escape_html => true

  get '/' do
    erb :index
  end

  get '/create' do
    erb :create
  end

  post '/create' do

    if params[:image]
      # Generate unique image name to prevent collisions / enumeration
      params[:image][:filename] =~ (/\.(png|jpeg|jpg|gif)$/i)
      filename = "#{SecureRandom.hex}.#{$1}"

      # Create new thread to asynchronously upload image to S3
      Thread.new do
        s3 = Aws::S3::Resource.new(region:'us-east-1')
        obj = s3.bucket(ENV['S3_BUCKET']).object(filename)
        obj.upload_file(params[:image][:tempfile].path)
      end

      image_url = "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{filename}"
    end

    event = Event.new(
      name: params[:name],
      host: params[:host],
      address: params[:address],
      description: params[:description],
      email: params[:email],
      date: params[:date],
      image: image_url
    )
    event.save!

    Pony.mail(:to => params[:email],
              :from => 'rsvp@example.com',
              :subject => 'Thanks for creating an event!',
              :html_body => erb(:email, locals: {event: event}))

    redirect to("/event/#{event[:id]}/manage")
  end

  get '/event/:id' do |id|
    erb :event, locals: { event: Event.find_by_id(id) }
  end

  post '/event/:id' do |id|
    Guest.new(
      event_id: id,
      name: params[:name],
      email: params[:email],
      status: params[:status]
    ).save!

    erb :thankyou, locals: { event: Event.find_by_id(id) }
  end

  get '/event/:id/manage' do |id|
    guests = Guest.where("event_id = ?", id).group_by { |guest| guest[:status] }
    erb :manage, locals: { event: Event.find_by_id(id), guests: guests }
  end

end
