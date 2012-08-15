class Test 
 #Methode zum normalisieren der Wörter im Feed   
    def self.normalize(s)
       s.downcase.gsub(/[äÄ]/, "ae").gsub(/[öÖ]/, "oe").gsub(/[üÜ]/, "ue").gsub(/[ß]/, "ss").gsub(/[^a-zA-Z\ ]/,"").split.uniq
    end 
 #Die stopwörter werden mit den Feeds abgeglichen   
    def self.deletewords(stopwords, feed)
        puts "---------Array---------"
        puts feed.to_s
        puts "---------Array---------"
            
        stopwords.each do |i| 
            if feed.include?(i) == true
                feed.delete(i)
                puts "Wort '#{i}' geloescht"
            end
            
        end
        
        puts "---------Array---------"
        puts feed.to_s
        puts "---------Array---------"
   end
  
 #Stopp wörter weden eingelesen und als array gespeichert   
    f = File.open("public/germanstopwords")
    f_lines = f.read.split("\n")

 # alle feeds aus der Spalte summary werden heruasgelesen und als string gespeichert und in die methode normalizer übergeben
    feeds = FeedEntry.pluck(:summary).to_s
    feeds = normalize(feeds)
 # Stoppwörter werden aus den feeds  gelöscht 
    deletewords(f_lines, feeds)



end
