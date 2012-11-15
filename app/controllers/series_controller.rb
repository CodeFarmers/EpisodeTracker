class SeriesController < ApplicationController
  def search
    @series = Series.find_by_name(params[:series])
    if @series
      #render series show page
    else
      ac = ApiConnector.new
      ac.get_series(params[:series])
      @series = Series.create()
    end
  end
end
