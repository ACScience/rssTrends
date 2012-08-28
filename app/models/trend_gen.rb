class TrendGen < FeedPrep

	private	

	def self.createTrends()
	
		# Auslesen der deutschen Stoppwörter aus der Datei
		stopwords = readstopwords
		
		# Auslesen der aktuellen Feeds aus der Datenbank
		feed_entries = readfeeds

		# Vorbereiten der neuen/hinzugekommenen Feeds zur Trendgenerierung
		feed_entries.each do |feed_entry|
			unless feed_entry.processed == true
				currentFeedId = feed_entry.id
				puts "Test: #{currentFeedId}"
				feeds = normalize(feed_entry.summary)
				normalized_feed = nil
				normalized_feed = deletewords(stopwords, feeds)
					
				# Abgleich potentieller Trendwörter mit der Datenbank
				normalized_feed.each do |w|
					w.to_s
					double = Trend.all
					double.each do |d|
					currentTrendId = d.id
						# Update eines bestehenden Trends (Trendwort existiert schon in der Datenbank)
						if (d.trendy_word == w) == true
							d.update_attributes(:counter => d.counter + 1)
							relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
							relation.save
							puts "plus1"
							w = "nil"
						end
					end
					# Anlegen eines neuen Trends (Trendwort noch nicht in der Datenbank vorhanden)
					unless w == "nil"
						trend = Trend.new(:trendy_word => w)
						trend.save
						currentTrend = Trend.find_by_trendy_word(w)
						currentTrendId = currentTrend.id
						relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
							relation.save
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
	
	def self.deleteTrends()
		outdatedTrends = Trend.where("updated_at < ?", 7.days.ago)
		outdatedTrends.each do |oT|			
			outdatedTrendId = oT.id
			outdatedRelations = Relation.find(:all, :conditions => {:trend_id => outdatedTrendId})
			oT.destroy			
				outdatedRelations.each do |oR|
					oR.destroy
				end
		end
	return true
	end
end
