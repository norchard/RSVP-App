#environment.rb
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'rsvp.sqlite3.db'
)