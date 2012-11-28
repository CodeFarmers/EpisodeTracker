class SeriesController < ApplicationController
  def find_or_create
    if params[:name].blank?
      flash.now[:alert] = "Why don't you try filling in the field?"
      render "search"
    else
      @series = Series.find_by_name(params[:name])
      if @series
        render :show
      else
        ac = ApiConnector.new
        @remote_series = ac.get_series_from_remote(params[:name])
        @remote_series.each do |id, series|
          Series.create(:name => series[:series_name], :overview => series[:series_overview], :remote_id => series[:series_id])
        end
        render :select_for_show
      end
    end
  end

  def search

  end
end
