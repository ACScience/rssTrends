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
	  feedadresses = FeedAdress.all
	  feedadresses.each do |feedadress| 
			@feed_gen = FeedGen.update_from_feed(feedadress.url)
			TrendGen.createTrends
			end 
			redirect_to :back
	end

end
