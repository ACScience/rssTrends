class TrendGen < FeedPrep
	
	def self.createTrends()
	
		# Auslesen der deutschen Stoppwörter aus der Datei
		stopwords = readstopwords
		
		# Auslesen der aktuellen Feeds aus der Datenbank
		feed_entries = readfeeds

		# Vorbereiten der neuen/hinzugekommenen Feeds zur Trendgenerierung
		feed_entries.each do |feed_entry|
			unless feed_entry.processed == true
				feeds = normalize(feed_entry.summary)
				normalized_feed = nil
				normalized_feed = deletewords(stopwords, feeds)
					
				# Abgleich potentieller Trendwörter mit der Datenbank
				normalized_feed.each do |w|
					w.to_s
					double = Trend.all
					double.each do |d|
						# Update eines bestehenden Trends (Trendwort existiert schon in der Datenbank)
						if (d.trendy_word == w) == true
							d.update_attributes(:counter => d.counter + 1)
							puts "plus1"
							w = "nil"
						end
					end
					# Anlegen eines neuen Trends (Trendwort noch nicht in der Datenbank vorhanden)
					unless w == "nil"
						trend = Trend.new(:trendy_word => w)
						trend.save
						puts "gespeichert"
					end
				end
				
				# Markieren der Feeds aus denen bereits Trends generiert, bzw. upgedated wurden (ermöglicht das Erkennen der neu hinzugekommenen Feeds nach einem Feed-Update)
				feed_entry.update_attributes(:processed => true)
				puts feed_entry.processed
				puts feed_entry.id
			end
		end
	end
end
