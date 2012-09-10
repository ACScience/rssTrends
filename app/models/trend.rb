class Trend < ActiveRecord::Base
  attr_accessible :counter, :trendy_word, :category

	has_many :relations
	has_many :feed_entries, :through => :relations

  def self.counterupdate
    trends = Trend.all
    trends.each do |trend|
      trend.update_attributes(:counter => trend.feed_entries.count)
    end
    Trend.destroy_all(['counter = ?', 0])
  end

  
end
# == Schema Information
#
# Table name: trends
#
#  id          :integer         not null, primary key
#  trendy_word :string(255)
#  counter     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

