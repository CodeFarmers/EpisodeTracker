class Episode < ActiveRecord::Base
  belongs_to :series
  validates_presence_of :name
  attr_accessible :name, :overview, :series_id
end

