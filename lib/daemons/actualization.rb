#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/application"
Rails.application.require_environment!

$running = true
Signal.trap("TERM") do 
  $running = false
end

$newInstance = true
	
while($running) do
		
	# Erstellen einer Logdatei, um die Zeitintervalle
	# überprüfen zu können (während der Daemon aktiv ist)
	if($newInstance == true)
	f = File.open(Rails.root + "log/update.log", "w")
	f.write("######################################\n")
	f.write("Logfile => aktuelle Update-Intervalle\n")
	f.write("######################################\n\n")
	f.close
	$newInstance = false
	end
	
	# Update Zeitpunkte in der update.log Datei anhängen
	f = File.open(Rails.root + "log/update.log", "a")
	f.write(Time.now)
	f.write("\n")
	f.close
		
	# Abfragen und Empfangen neuer Feeds
	feedOrigins = FeedOrigin.all
	feedOrigins.each do |feedorigin|
	FeedGen.update_from_feed(feedorigin.url, feedorigin.category)
	end
	
	# Trend Erstellung starten
	TrendGen.createTrends
	
	# Veraltete Feeds löschen und betroffene Trends updaten
	FeedEntry.deletetrends(2.days.ago)
	
	# 2 Stunden warten bis zum nächsten Update
	sleep 7200
end
