class SeriesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:show]

  #def find_or_create
  #  if params[:name].blank?
  #    flash.now[:alert] = "Why don't you try filling in the field?"
  #    render :search
  #  else
  #    @series = Series.where('lower(name) = ?', params[:name].downcase).first
  #    if @series
  #      render :show
  #    else
  #      ac = ApiConnector.new
  #      remote_series = ac.get_series_from_remote(params[:name])
  #      @series_array = []
  #      remote_series.each do |series|
  #        @series_array << Series.create(:name => series[:series_name], :overview => series[:series_overview], :remote_id => series[:series_id])
  #      end
  #      if remote_series.length == 1
  #        @series = @series_array.first
  #        render :show
  #      else
  #        render :select_for_show
  #      end
  #    end
  #  end
  #end

  def search_remote
    if params[:name].blank?
      flash.now[:alert] = "Why don't you try filling in the field?"
      render :search_remote
    else
      ac = ApiConnector.new
      remote_series = ac.get_series_from_remote(params[:name])
      ap remote_series

      remote_series.each do |series|
        Series.create(:name => series[:series_name], :overview => series[:series_overview], :remote_id => series[:series_id])
      end
    end
  end

end

