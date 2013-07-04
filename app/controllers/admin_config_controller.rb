class AdminConfigController < ApplicationController
  before_filter :authenticate_user!
  def show
    authorize! :manage, :all
    @series = Series.all
    render :show
  end

  def search
    render "series/search_remote"
  end
end
