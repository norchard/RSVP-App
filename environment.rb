#environment.rb
require 'active_record'
require 'sinatra/activerecord'
require 'pony'


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

configure :production do
  Pony.options =  {
    :via => :smtp,
    :via_options => {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    },
  }
end