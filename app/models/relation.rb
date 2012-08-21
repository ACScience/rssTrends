class Relation < ActiveRecord::Base
attr_accessible :created_at, :feed_id, :feed_name, :feed_text, :feed_url, :published_at, :trend_counter, :trend_id, :trendy_word, :updated_at

	belongs_to :feed_entry
	belongs_to :trend

end
