class UserEpisode < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  attr_accessible :user_id, :episode_id
end