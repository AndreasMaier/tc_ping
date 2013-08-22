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

credentials = sg_username = sg_password = rds_host = rds_port = rds_password = ''
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
  #  redis = Redis.new(host: rds_host, port: rds_port, password: rds_password)
  #
  #  results.each do |item|
  #    # if id is not in db
  #    unless redis.get(item["id"])
  #      Mail.deliver do
  #        to 'andreas.maier@gmail.com'
  #        from 'token@tcping.com'
  #        subject 'Event triggered on Hackernews'
  #        body "<div>Keywords were found in the news with the title</div><div>#{item.text.strip}</div><a href=#{item["href"]}>link</a>"
  #      end
  #    end
  #  end
  #end
  #
  #some_var = some_var + 1
end

get '/' do
  response = Nokogiri::HTML(open('http://www.techcrunch.com'))

  results = []
  response.css('.left-container .post .headline a').each do |item|
    if item.text =~ /(Disrupt|Hackathon|Jimdo)/
      results << item
    end
  end

  unless results.empty?
    redis = Redis.new(host: rds_host, port: rds_port, password: rds_password)

    results.each do |item|
      # if id is not in db
      unless redis.get(item["id"])
        Mail.deliver do
          to 'andreas.maier@gmail.com'
          from 'token@tcping.com'
          subject 'Event triggered on Techcrunch'
          body "Keywords were found in the news with the title\n\n#{item.text.strip}\n\n#{item["href"]}"
        end

        redis.set(item["id"], item["href"])
      end
    end
  end

  some_var = some_var + 1

  "Hello world! #{some_var} new \n\n"
end
