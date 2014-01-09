class AdminConfigController < ApplicationController
  before_filter :authenticate_user!
  rescue_from ActionController::RoutingError, :with => :not_found
  respond_to :json, :only => [ :search_remote ]

  def show
    authorize! :manage, :all
    @series = Series.all
    render :show
  end

  def update
    authorize! :manage, :all
    series = Series.find(params[:id])
    if series.needs_update?
      ##TODO: Do updating here
    else
      flash.now[:alert] = "No updates available for #{series.name}"
      @series = Series.all
      render :show
    end
  end

  def search
    authorize! :manage, :all
    render "admin_config/search_remote"
  end

  def search_remote
    authorize! :manage, :all
    @series = []

    if params[:name].blank?
      flash.now[:alert] = "Why don't you try filling in the field?"
      render :search_remote
    else
      ac = ApiConnector.new
      remote_series = ac.get_series_from_remote(params[:name])

      remote_series.each do |series|
        @series << Series.create(name: series[:series_name], overview: series[:series_overview], remote_id: series[:series_id], last_remote_update: series[:last_remote_update])
      end
    @series
    end
  end
end
