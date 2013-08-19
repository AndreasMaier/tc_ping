require 'sinatra'
require 'rufus/scheduler'
require 'httparty'
require 'mail'

scheduler = Rufus::Scheduler.start_new
some_var = 1

#Mail.defaults do
#  delivery_method :smtp, {
#      :address => 'smtp.sendgrid.net',
#      :port => 587,
#      :domain => 'something',
#      :user_name => 'mUwE512IyA',
#      :password => 'aEMTgKY1Sl',
#      :authentication => 'plain',
#      :enable_starttls_auto => true
#  }
#end

#mail = Mail.deliver do
#  to 'andreas.maier@gmail.com'
#  from 'someone@example.com'
#  subject 'Feedback for my Sintra app'
#end

scheduler.every '1m' do
  some_var = some_var + 1
end

get '/' do
  #response = HTTParty.get('http://techcrunch.com/')
  "Hello world! #{some_var}\n\n#{ENV['VCAP_SERVICES']}"
end

#{
#  "sendgrid-n/a": [
#        {
#            "name":"email_sender",
#            "label":"sendgrid-n/a",
#            "tags":[],
#            "plan":"free",
#            "credentials": {
#              "username":"mUwE512IyA",
#              "hostname":"smtp.sendgrid.net",
#              "password":"aEMTgKY1Sl"
#            }
#        }
#  ]
#}
