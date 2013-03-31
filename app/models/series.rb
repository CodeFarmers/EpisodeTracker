class Series < ActiveRecord::Base
  has_many :episodes, :dependent => :destroy, :primary_key=> "remote_id"
  attr_accessible :name, :overview, :remote_id
  validates :name, presence: true, uniqueness: true
end