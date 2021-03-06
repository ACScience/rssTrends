class FeedEntry < ActiveRecord::Base
  attr_accessible :id, :name, :published_at, :summary, :url, :category, :processed
		
	has_many :relations
	has_many :trends, :through => :relations	


  # Methode löscht veraltete Feeds und updated die zugehörigen Trends
  def self.deletetrends(time)
    FeedEntry.destroy_all(['published_at < ?', time])
    Trend.counterupdate
  end
  
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
