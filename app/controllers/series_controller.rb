class SeriesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, only: [ :index ]

  def index
    @series = Series.search(params[:search])
  end
end

