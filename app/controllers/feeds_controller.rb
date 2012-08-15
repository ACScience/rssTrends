class FeedsController < ApplicationController
	def index
	    @feed = FeedEntry.all 
	end
	
	def show
        @feed = FeedEntry.find(params[:id])
    end

	def new
			FeedEntry.update_from_feed("http://www.spiegel.de/politik/index.rss")
	end
end
