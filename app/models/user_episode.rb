class UserEpisode < ActiveRecord::Base
  belongs_to :user
  belongs_to :episode
  validates_uniqueness_of :episode_id, scope: :user_id
  validates_presence_of :user_id, :episode_id
  attr_accessible :user_id, :episode_id
end