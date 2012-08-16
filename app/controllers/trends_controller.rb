class TrendsController < ApplicationController
  def index
  @feed_entries = FeedEntry.all
  end

  def show
  end

  def destroy
  end
end
