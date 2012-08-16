class Test 
 # Methode zum normalisieren der Wörter im Feed   
	private	
		def self.normalize(s)
       s.downcase.gsub(/[äÄ]/, "ae").gsub(/[öÖ]/, "oe").gsub(/[üÜ]/, "ue").gsub(/[ß]/, "ss").gsub(/[^a-zA-Z\ ]/,"").split.uniq
    end 
 # Die stopwörter werden mit den Feeds abgeglichen   
    def self.deletewords(stopwords, feed)
#        puts "---------Array---------"
#        puts feed.to_s
#        puts "---------Array---------"
            
        stopwords.each do |i| 
            if feed.include?(i) == true
                feed.delete(i)
#                puts "Wort '#{i}' geloescht"
            end
            
        end
        
#        puts "---------Array---------"
#        puts feed.to_s
#        puts "---------Array---------"

				return feed
   end
   

 #Die Feeds werden für die Trendgenerierung vorbereitet -> Normalisierung und Löschen der  Stoppwörter

	public
		
		def self.prepare_feeds()
			 # Stopp wörter weden eingelesen und als array gespeichert   
   		 f = File.open("public/germanstopwords")
   		 f_lines = f.read.split("\n")
       feed_entries = FeedEntry.all
 			# alle feeds aus der Spalte summary werden heruasgelesen und als string gespeichert und in die methode normalizer übergeben
#   		 feeds = FeedEntry.pluck(:summary).to_s
      
      feed_entries.each do |feed_entry|
        unless feed_entry.processed == true
   		    feeds = normalize(feed_entry.summary)
 			    normalized_feed = nil
    	    normalized_feed = deletewords(f_lines, feeds)     #Stoppwörter werden aus den feeds  gelöscht 
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
              trend = Trend.new(trendy_word: w)
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

 prepare_feeds

end
