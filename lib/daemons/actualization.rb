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
  
  # Replace this with your code
  #Rails.logger.auto_flushing = true
  #Rails.logger.info "This daemon is still running at #{Time.now}.\n"
  
  #sleep 10

	FeedGen.update_from_feed("http://www.spiegel.de/politik/index.rss")
	sleep 120
	#Rails.logger.info "Current Dir: #{Dir.pwd}\n"
	TrendGen.createTrends
	sleep 10000
end
