# app.rb
require 'sinatra'
require "sinatra/reloader" if development?
require_relative 'environment'
require_relative 'models'
require 'erubis'

class RsvpApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
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
    event = Event.new(
      name: params[:name],
      host: params[:host],
      address: params[:address],
      description: params[:description],
      email: params[:email],
      date: params[:date]
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
