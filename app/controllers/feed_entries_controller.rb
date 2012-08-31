class FeedEntriesController < ApplicationController
	
	def index
  if(params.has_key?(:category))
	  @feed_entries = FeedEntry.where("category = ?", params[:category]).paginate(:page => params[:page], :per_page => 15)
  else
  @feed_entries = FeedEntry.paginate(:page => params[:page], :per_page => 15)
  end
end
	
	def show
      @feed_entry = FeedEntry.find(params[:id])
      
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @feed }
    end
  end

	def new
	  feedorigins = FeedOrigin.all
	  feedorigins.each do |feedorigin| 
			@feed_gen = FeedGen.update_from_feed(feedorigin.url, feedorigin.category)
			TrendGen.createTrends
			end 
			redirect_to :back
	end

end
