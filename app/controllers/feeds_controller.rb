class FeedsController < ApplicationController
	def index
	    @feed = FeedEntry.all 
	end
	
	def show
      @feed = FeedEntry.find(params[:id])
      
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @feed }
    end
  end

	def new
			@feed = FeedEntry.update_from_feed("http://www.spiegel.de/politik/index.rss")				
			
			redirect_to '/feeds.html'
	end

end
