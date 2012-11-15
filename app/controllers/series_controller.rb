class SeriesController < ApplicationController
  def find_or_create
    if params[:name].blank?
      flash.now[:alert] = "Why don't you try filling in the field?"
      render "search"
    else
      @series = Series.find_by_name(params[:name])
      if @series
        #render series show page
        ap "Series found"
      else
        ac = ApiConnector.new
        series = ac.get_series_from_remote(params[:name])
        @series = Series.new(:name => series[:series_name], :overview => series[:series_overview], :remote_id => series[:series_id])
        ap @series
        ap @series.valid?
      end
    end

  end

  def search
  end
end
