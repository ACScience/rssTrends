class TrendsController < ApplicationController
  def index
	if(params.has_key?(:category))
	  @trends = Trend.where("category = ?", params[:category]).paginate(:page => params[:page], :per_page => 15).order("counter DESC")
	else
	@trends = Trend.where(:category => "Allgemein").paginate(:page => params[:page], :per_page => 15).order("counter DESC")
	end
  end


  def show
  @trend = Trend.find(params[:id])
  @relation = Relation.find(:all,:conditions => {:trend_id => @trend.id})
  @feed_entries = FeedEntry.all
  end

  def destroy
  end
end
