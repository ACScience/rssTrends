class TrendsController < ApplicationController
  def index
  @trends = Trend.find(:all, :order => 'counter DESC')
  end

  def show
  @trend = Trend.find(params[:id])
  @relation = Relation.find(:all,:conditions => {:trend_id => @trend.id})
  @feed_entries = FeedEntry.all
  end

  def destroy
  end
end
