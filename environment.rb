#environment.rb
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database =>  'rsvp'
)