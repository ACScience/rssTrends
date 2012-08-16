require 'test_helper'

class FeedEntryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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

