class TrendsController < ApplicationController
  def index
    if(params.has_key?(:category))
      @trends = Trend.where("category = ?", params[:category]).paginate(:page => params[:page], :per_page => 15).order("counter DESC")
    else
      @trends = Trend.where(:category => "Allgemein").paginate(:page => params[:page], :per_page => 15).order("counter DESC")
    end
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @trends }
      format.xml { render :xml => @trends }
    end
  end


  def show
    @trend = Trend.find(params[:id])
    @trend_entries=@trend.feed_entries.paginate(:page => params[:page], :per_page => 15).order("published_at DESC")

      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @trend}
      format.xml { render :xml => @trend}
    end
  end

  def destroy
  end
end
