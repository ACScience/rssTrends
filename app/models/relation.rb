class Relation < ActiveRecord::Base
attr_accessible :created_at, :feed_entry_id, :feed_name, :feed_summary, :feed_url, :published_at, :trend_counter, :trend_id, :trendy_word, :updated_at

	belongs_to :feed_entry
	belongs_to :trend

end
