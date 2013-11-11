class EpisodesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :only => [:create]

  def create
    authorize! :manage, :all
    @ac = ApiConnector.new
    @series = Series.where(:remote_id => params[:remote_id]).first
    if @series.episodes.present?
      flash[:alert] = "It looks like you already have the episodes for that series!"
    else
      episodes = @ac.get_episodes(params[:remote_id])
      episodes.each do |episode|
        name = episode.elements["EpisodeName"].text
        overview = episode.elements["Overview"].text
        season = episode.elements["SeasonNumber"].try(:text).to_i
        name.nil? ? name = "This episode has no name" : name
        Episode.create!(:name => name, :overview => overview, :series_id => params[:remote_id], :season => season)
      end
    end
    redirect_to series_episodes_path(@series)
  end

  def index
    @series = Series.find(params[:series_id])
    #@episodes = @series.episodes.paginate(:page => params[:page], :per_page => 10)
    @episodes_grouped_by_season = @series.episodes.group_by(&:season)
  end
end
