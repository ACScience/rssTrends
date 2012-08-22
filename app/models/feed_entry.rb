class FeedEntry < ActiveRecord::Base
  attr_accessible :id, :name, :published_at, :summary, :url, :processed
		def self.update_from_feed(feed_url)
			feed = Feedzirra::Feed.fetch_and_parse(feed_url)
			feed.entries.each do |entry|
				unless exists? :url => entry.url or entry.summary == nil
					create!(
						:name								=> entry.title,
						:summary						=> entry.summary,
						:url								=> entry.url,
						:published_at				=> entry.published
			
					)
				end
			end
		end
		
	has_many :relations
	has_many :trends, :through => :relations	

	end

# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer         not null, primary key
#  name         :string(255)
#  summary      :text
#  url          :string(255)
#  published_at :datetime
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  processed    :boolean         default(FALSE)
#

