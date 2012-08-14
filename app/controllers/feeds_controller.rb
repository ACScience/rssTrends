class FeedsController < ApplicationController
	def index
	@feed = FeedEntry.all 
	end
end
