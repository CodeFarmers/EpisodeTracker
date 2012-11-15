class Series < ActiveRecord::Base
  attr_accessible :name, :overview, :remote_id
  validates :name, presence: true, uniqueness: true
end