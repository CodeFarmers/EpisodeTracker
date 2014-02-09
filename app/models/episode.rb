class Episode < ActiveRecord::Base
  belongs_to :series, primary_key: :remote_id
  has_many :user_episodes
  has_many :users, through: :user_episodes
  validates_presence_of :name
  attr_accessible :name, :overview, :series_id, :season, :air_date, :remote_id
end

