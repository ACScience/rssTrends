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
				currentFeedCat = feed_entry.category
				puts "Test: #{currentFeedId}"
				feeds = normalize(feed_entry.summary)
				normalized_feed = nil
				normalized_feed = deletewords(stopwords, feeds)
					
				# Abgleich potentieller Trendwörter mit der Datenbank
				normalized_feed.each do |w|
					w.to_s
					# Trend wird nur erstellt wenn das potentielle Trendwort aus mehr als einem Buchstaben besteht
					if w.length != 0
						double = Trend.all
						double.each do |d|
						currentTrendId = d.id
							# Update eines bestehenden Trends (Trendwort existiert schon in der Datenbank)
							if (d.trendy_word == w) == true && (d.category == currentFeedCat) == true
								relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
								relation.save


								gT = Trend.find_by_trendy_word_and_category(w, "General")
								currentTrendId = gT.id								
								# Kein zusätzlicher Check nötig, da es schon in einer anderen Kategorie existiert => und somit auch als allgemeiner Trend								
								relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
								relation.save										
								
								w = "nil"

							end
						end
							# Anlegen eines neuen Trends (Trendwort noch nicht in der Datenbank vorhanden)
							unless w == "nil"
								trend = Trend.new(:trendy_word => w, :category => currentFeedCat)
								trend.save
								currentTrend = Trend.find_by_trendy_word_and_category(w, currentFeedCat)
								currentTrendId = currentTrend.id
								relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
								relation.save
								puts "gespeichert"
		
								gT = Trend.find_by_trendy_word_and_category(w, "General")
									if gT != nil
										currentTrendId = gT.id
										relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
										relation.save
									else
										gT = Trend.new(:trendy_word => w, :category => "General")
										gT.save
										currentTrend = Trend.find_by_trendy_word_and_category(w, "General")
										currentTrendId = currentTrend.id
										relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
										relation.save
									end
								end
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
