class AdminConfigController < ApplicationController
  before_filter :authenticate_user!
  def show
    authorize! :manage, :all
    @series = Series.all
    render :show
  end

  def search
    authorize! :manage, :all
    render "admin_config/search_remote"
  end

  def search_remote
    authorize! :manage, :all

    if params[:name].blank?
      flash.now[:alert] = "Why don't you try filling in the field?"
      render :search_remote
    else
      ac = ApiConnector.new
      remote_series = ac.get_series_from_remote(params[:name])
      ap remote_series.class

      remote_series.each do |series|
        Series.create(:name => series[:series_name], :overview => series[:series_overview], :remote_id => series[:series_id])
      end
    end
  end
end
