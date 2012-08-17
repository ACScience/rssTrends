class TrendGen < FeedPrep
	
	def self.createTrends()

		stopwords = readstopwords
		
		feed_entries = readfeeds

		feed_entries.each do |feed_entry|
			unless feed_entry.processed == true
				feeds = normalize(feed_entry.summary)
				normalized_feed = nil
				normalized_feed = deletewords(stopwords, feeds)
				
				normalized_feed.each do |w|
					w.to_s
					double = Trend.all
					double.each do |d|
						if d.trendy_word.include?(w) == true
							d.update_attributes(:counter => d.counter + 1)
							puts "plus1"
							w = "nil"
						end
					end

					unless w == "nil"
						trend = Trend.new(:trendy_word => w)
						trend.save
						puts "gespeichert"
					end
				end
			
				feed_entry.update_attributes(:processed => true)
				puts feed_entry.processed
				puts feed_entry.id
			end
		end
	end
end
