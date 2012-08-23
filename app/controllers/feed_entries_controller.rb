class FeedEntriesController < ApplicationController
	def index
	  @feed_entries = FeedEntry.all(:order => 'id') 
	end
	
	def show
      @feed_entry = FeedEntry.find(params[:id])
      
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @feed }
    end
  end

	def new
			@feed_entry = FeedEntry.update_from_feed("http://www.spiegel.de/politik/index.rss")
			Starter.createTrends
			redirect_to :back
	end

end
