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

	# Checking for outdated trends before udpating the feeds
	checkedForOutdatedTrends = false
	while(checkedForOutdatedTrends == false) do
		checkedForOutdatedTrends = TrendGen.deleteTrends
	end

	# Checking if update_from_feed method has returned
	feedsRetrieved = false
	while(feedsRetrieved == false) do
		feedsRetrieved = FeedGen.update_from_feed("http://www.spiegel.de/politik/index.rss")
	end
	
	# Finished retrieving feeds -> starting Trendgeneration
	TrendGen.createTrends
	
	# Waiting 2 hour until next update
	sleep(2.hours)

end
