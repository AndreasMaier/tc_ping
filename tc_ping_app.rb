require 'sinatra'
require 'rufus/scheduler'
require 'httparty'
require 'mail'
require 'json'
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'redis'

scheduler = Rufus::Scheduler.start_new
some_var = 1

credentials = sg_username = sg_password = rds_host = rds_port = rds_username = rds_password = ''
if !ENV['VCAP_SERVICES'].blank?
  JSON.parse(ENV['VCAP_SERVICES']).each do |k,v|
    if !k.scan("sendgrid").blank?
      credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
      sg_username = credentials["username"]
      sg_password = credentials["password"]
    end

    if !k.scan("rediscloud").blank?
      credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
      rds_host = credentials["hostname"]
      rds_port = credentials["port"]
      rds_username = credentials["username"]
      rds_password = credentials["password"]
    end
  end
end

Mail.defaults do
  delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :domain => 'something',
      :user_name => sg_username,
      :password => sg_password,
      :authentication => 'plain',
      :enable_starttls_auto => true
  }
end

scheduler.every '1m' do
  #response = Nokogiri::HTML(open('http://www.techcrunch.com'))
  #
  #results = []
  #response.css('.left-container .post .headline a').each do |item|
  #  if item.text =~ /(Disrupt|Hackathon|Jimdo)/
  #    results << item
  #  end
  #end
  #
  #unless results.empty?
  #  redis = Redis.new( host:  )
  #
  #  results.each do |item|
  #    # get id
  #    id = get_news_id item
  #    # if id is not in db
  #
  #    # get header
  #    # get link
  #    # send email
  #  end
  #end


  #mail = Mail.deliver do
  #  to 'andreas.maier@gmail.com'
  #  from 'token@tcping.com'
  #  subject 'Feedback for my Sintra app'
  #end
  some_var = some_var + 1
end

def get_news_id(item)
  item["id"]
end

get '/' do


  r = Redis.new(host: "pub-redis-19494.us-east-1-4.1.ec2.garantiadata.com", port: "19494")

  r.set('somekey', 'stuff')
  a = r.get('somekey')
  b = r.get('otherkey')

  puts "a #{a}"
  puts "b #{b}"

  "Hello world! #{some_var}\n\n"
end
