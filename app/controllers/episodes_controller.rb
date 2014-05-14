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
        air_date = episode.elements["FirstAired"].try(:text) || '01/01/2100'.to_date
        remote_id = episode.elements["id"].text
        name.nil? ? name = "This episode has no name" : name
        Episode.create!(name: name, overview: overview, series_id: params[:remote_id], season: season, air_date: air_date, remote_id: remote_id)
      end
    end
    redirect_to series_episodes_path(@series)
  end

  def index
    @series = Series.find(params[:series_id])
    #@episodes = @series.episodes.paginate(:page => params[:page], :per_page => 10)
    @episodes_grouped_by_season = @series.episodes.sort_by(&:air_date).group_by(&:season).sort

    episodes =  @series.episodes.includes(:user_episodes)

    @user_episodes = {}
    episodes.each do | episode |
      user_episode = episode.user_episodes.first
      if user_episode && user_episode.user_id == current_user.id
        @user_episodes.merge!({ episode.id => episode.user_episodes.first })
      end
    end
    @user_episodes
  end
end
