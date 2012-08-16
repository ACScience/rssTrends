class TrendsController < ApplicationController
  def index
  @trends = Trend.find(:all, :order => 'counter')
  end

  def show
  end

  def destroy
  end
end
