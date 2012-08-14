class FeedEntry < ActiveRecord::Base
  attr_accessible :id, :name, :published_at, :summary, :url
		def self.update_from_feed(feed_url)
			feed = Feedzirra::Feed.fetch_and_parse(feed_url)
			feed.entries.each do |entry|
				unless exists? :url => entry.url
					create!(
						:name								=> entry.title,
						:summary						=> entry.summary,
						:url								=> entry.url,
						:published_at				=> entry.published,
			
					)
				end
			end
		end
	end
