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

	feedsRetrieved = false
	# Checking if update_from_feed method has returned
	while(feedsRetrieved == false) do
	feedsRetrieved = FeedGen.update_from_feed("http://www.spiegel.de/politik/index.rss")
	end
	
	# Finished retrieving feeds -> starting Trendgeneration
	#Rails.logger.info "Current Dir: #{Dir.pwd}\n"
	TrendGen.createTrends
	
	# Waiting 10 minutes until next update
	sleep 10000

end
