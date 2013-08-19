require 'sinatra'
require 'rufus/scheduler'
require 'httparty'
require 'mail'
require 'json'

scheduler = Rufus::Scheduler.start_new
some_var = 1

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

Mail.defaults do
  delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :domain => 'something',
      :user_name => username,
      :password => password,
      :authentication => 'plain',
      :enable_starttls_auto => true
  }
end

scheduler.every '1m' do
  #mail = Mail.deliver do
  #  to 'andreas.maier@gmail.com'
  #  from 'token@tcping.com'
  #  subject 'Feedback for my Sintra app'
  #end
  some_var = some_var + 1
end

get '/' do
  #response = HTTParty.get('http://techcrunch.com/')
  "Hello world! #{some_var}\n\n"
end
