class FeedEntriesController < ApplicationController
#require'kaminari'
	def index
	  @feed_entries = FeedEntry.paginate(:page => params[:page], :per_page => 15)
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
