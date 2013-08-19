require 'sinatra'
require 'rufus/scheduler'
require 'httparty'
require 'mail'
require 'json'

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
  credentials = host = username = password = ''
  if !ENV['VCAP_SERVICES'].blank?
    JSON.parse(ENV['VCAP_SERVICES']).each do |k,v|
      if !k.scan("sendgrid").blank?
        credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
        host = credentials["hostname"]
        username = credentials["username"]
        password = credentials["password"]
      end
    end
  end
  "Hello world! #{some_var}\n\nusername: #{username}\npassword: #{password}"
end

#{"sendgrid-n/a":[{"name":"email_sender","label":"sendgrid-n/a","tags":[],"plan":"free","credentials": {"username":"mUwE512IyA","hostname":"smtp.sendgrid.net","password":"aEMTgKY1Sl"}}]}
