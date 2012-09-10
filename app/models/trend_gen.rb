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
								d.update_attributes(:counter => d.counter + 1)
								relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
								relation.save
								puts "plus1"

								gT = Trend.find_by_trendy_word_and_category(w, "Allgemein")
									# Eigentlich kein zusätzlicher Check nötig, da es schon in einer anderen Kategorie existiert => und somit auch als allgemeiner Trend
									# Check erkennt Inkonsistenz der Datenbank -> wenn zum Beispiel einzelne Trends aus Testzwecken über die Konsole gelöscht wurden
									if gT.id == nil
										puts "ERROR -> Inconsistent Relation"
									end
								currentTrendId = gT.id															
								gT.update_attributes(:counter => gT.counter + 1)
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
		
								gT = Trend.find_by_trendy_word_and_category(w, "Allgemein")
									if gT != nil
										currentTrendId = gT.id
										gT.update_attributes(:counter => gT.counter + 1)
										relation = Relation.new(:feed_entry_id => currentFeedId, :trend_id => currentTrendId)
										relation.save
									else
										gT = Trend.new(:trendy_word => w, :category => "Allgemein")
										gT.save
										currentTrend = Trend.find_by_trendy_word_and_category(w, "Allgemein")
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
	
	def self.deleteOutdatedTrends()
	outdatedTrends = Trend.where("updated_at < ?", 12.hours.ago)
	unless outdatedTrends == nil
	outdatedTrends.each do |oT|
		
		# Sichere die nötigen Trend Eigenschaften
		oTid = oT.id
		oTtrendy_word = oT.trendy_word
		oTcounter = oT.counter
		# Sichere die mit dem Trend assoziierten Feeds
		outdatedFeedRelations = Relation.where(:trend_id => oTid)
		
			# Handelt es sich um einen Trend der Kategorie "Allgemein" müssen auch die zugehörigen Trends anderer Kategorien gelöscht werden
			if (oT.category == "Allgemein") == true
			
				# Lösche Abhängigkeiten des aktuellen Trends
				outdatedRelations = oT.relations
				outdatedRelations.each do |oR|
					oR.destroy
				end
				
				# Lösche den aktuellen Trend
				oT.destroy
							
				# Lösche die Abhängigkeiten der zugehörigen Trends anderer Kategorien
				#dependentTrends = Trend.where(:trendy_word => oTtrendy_word)
				dependentTrends = Trend.find(:all, :conditions => ["trendy_word = ? AND category != ?", oTtrendy_word, "Allgemein"])
				dependentTrends.each do |dT|
					outdatedRelations = dT.relations
					outdatedRelations.each do |oR|
						oR.destroy
					end
					dT.destroy
				end
				
			else
			    # Handelt es sich um keinen Trend der Kategorie "Allgemein" werden dessen Abhängigkeiten gelöscht
				outdatedRelations = oT.relations
				outdatedRelations.each do |oR|
					oR.destroy
				end
				
				# Lösche den aktuellen Trend
				oT.destroy
				
				# Teste, ob der zugehörige allgemeine Trend noch aus einer anderen Kategorie besteht oder nicht
				#generalTrend = Trend.find_by_trendy_word_and_category(oTtrendy_word, "Allgemein")
				generalTrend = Trend.where(:trendy_word => oTtrendy_word, :category => "Allgemein")
				generalTrend.each do |gT|
					# Wenn der allgemeine Trend aus mehreren Trend Kategorien besteht -> update des allgemeinen Trends
					if (gT.counter - oTcounter > 0) == true
						gT.update_attributes(:counter => gT.counter - oTcounter)
					# Ansonsten, Löschen der Abhängigkeiten des allgemeinen Trends
					else
						outdatedRelations = gT.relations
						outdatedRelations.each do |oR|
							oR.destroy
						end
						# Lösche den veralteten Trend
						gT.destroy
					end
				end
			end
			
end
	# Lösche verwaiste Feeds
	tempRelations = FeedEntry.all
		tempRelations.each do |tR|
			if (tR.relations(true).empty?) == true
				tR.destroy
			end
		end

	return true			
end
end
end
