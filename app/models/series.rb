class Series < ActiveRecord::Base

  has_many :episodes, :dependent => :destroy, :primary_key=> "remote_id"

  attr_accessible :name, :overview, :remote_id
  validates :name, presence: true, uniqueness: true

  def self.search(search)
    if search
      Series.joins(:episodes).where("series.name like ?", "%" + search + "%")
    else
      Series.joins(:episodes)
    end
  end
end