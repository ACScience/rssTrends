class Trend < ActiveRecord::Base
  attr_accessible :counter, :trendy_word
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
