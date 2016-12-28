#environment.rb
require 'active_record'
require 'sinatra/activerecord'


# ActiveRecord::Base.establish_connection(
#   :adapter => 'postgresql',
#   :database =>  'rsvp'
# )

db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/rsvp')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)