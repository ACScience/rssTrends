class FeedGen	< FeedEntry	

	private

	# Empfangen und Speichern von Feeds einer angegebenen URL
	def self.update_from_feed(feed_url, feed_category)
		feed = Feedzirra::Feed.fetch_and_parse(feed_url)
		feed.entries.each do |entry|
			unless exists? :url => entry.url or entry.summary == nil
				create!(
					:name								=> entry.title,
					:summary						=> entry.summary,
					:category						=> feed_category.to_s,
					:url								=> entry.url,
					:published_at				=> entry.published
			
				)
			end
		end
		return true
	end
end
