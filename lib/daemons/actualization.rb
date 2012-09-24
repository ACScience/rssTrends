#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/application"
Rails.application.require_environment!

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do

	# Checking if update_from_feed method has returned
	feedOrigins = FeedOrigin.all
	feedOrigins.each do |feedorigin|
	FeedGen.update_from_feed(feedorigin.url, feedorigin.category)
	end
	
	# Finished retrieving feeds -> starting Trendgeneration
	TrendGen.createTrends
	FeedEntry.deletetrends(7.days.ago)

	# Waiting 2 hour until next update
	sleep(2.hours)
end
