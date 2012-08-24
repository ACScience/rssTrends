#!/bin/env ruby
# encoding: utf-8

class FeedPrep < FeedEntry

	private

		# Normalisieren der Wörter im Feed und löschen der doppelt vorkommenden Wörter
		def self.normalize(s)
       s.downcase.gsub(/[äÄ]/, "ae").gsub(/[öÖ]/, "oe").gsub(/[üÜ]/, "ue").gsub(/[ß]/, "ss").gsub(/[^a-zA-Z\ ]/,"").split.uniq
    end

		# Auslesen der deutschen Stoppwörter aus der Datei
		def self.readstopwords()
			f = File.open("public/germanstopwords")
			f_lines = f.read.split("\n")
			
			return f_lines

		end

		# Auslesen der aktuellen Feeds aus der Datenbank
		def self.readfeeds()
			feed_entries = FeedEntry.all
			
			return feed_entries

		end

 		# Löschen der Stoppwörter aus den Feeds   
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

end
