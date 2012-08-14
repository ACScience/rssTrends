class FeedsController < ApplicationController
	def index
	    @feed = FeedEntry.all 
	end
	
	def show
        @feed = FeedEntry.find(params[:id])
    end
end
