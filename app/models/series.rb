class Series < ActiveRecord::Base
  has_many :episodes
  attr_accessible :name, :overview, :remote_id
  validates :name, presence: true, uniqueness: true
end