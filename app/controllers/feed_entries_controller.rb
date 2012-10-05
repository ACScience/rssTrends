class FeedEntriesController < ApplicationController

	def index
		if(params.has_key?(:category))
			@feed_entries = FeedEntry.where("category = ?", params[:category]).paginate(:page => params[:page], :per_page => 15).order("published_at DESC")
		else
			@feed_entries = FeedEntry.paginate(:page => params[:page], :per_page => 15).order("published_at DESC")
		end
		respond_to do |format|
		format.html # show.html.erb
		format.json { render :json => @feed_entries }
		format.xml { render :xml => @feed_entries }
    end
	end
	
	def show
      @feed_entry = FeedEntry.find(params[:id])
      
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @feed_entry }
      format.xml { render :xml => @feed_entry }
    end
  end

	def new
	  feedorigins = FeedOrigin.all
	  feedorigins.each do |feedorigin| 
			@feed_gen = FeedGen.update_from_feed(feedorigin.url, feedorigin.category)
			end
			TrendGen.createTrends
			FeedEntry.deletetrends(7.days.ago)
			redirect_to :back
<<<<<<< HEAD
 	end
=======
	end
>>>>>>> master
end
