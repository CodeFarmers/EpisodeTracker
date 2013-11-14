class UserEpisodesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json, :only => [ :create ]

  def create
    @user_episode = UserEpisode.create(user_id: params[:user_id], episode_id: params[:episode_id])
  end
end