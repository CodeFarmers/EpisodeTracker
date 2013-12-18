class SeriesController < ApplicationController
  before_filter :authenticate_user!
  rescue_from ActionController::RoutingError, :with => :not_found
  respond_to :json, only: [ :index ]

  def index
    @series = Series.search(params[:search])
  end
end

