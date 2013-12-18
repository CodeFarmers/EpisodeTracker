class Series < ActiveRecord::Base

  has_many :episodes, :dependent => :destroy, :primary_key=> "remote_id"

  attr_accessible :name, :overview, :remote_id
  validates :name, presence: true, uniqueness: true

  def self.search(search)
    if search
      #ap Series.all
      #ap Episode.all
      #ap Series.joins(:episodes).uniq.where("series.name like ?", "%" + search + "%")
      series = Series.joins(:episodes).uniq.where("series.name ilike ?", "%" + search + "%")
      if series.any?
        series
      else
        raise ActionController::RoutingError.new('Series not found')
      end
    else
      Series.joins(:episodes).uniq
    end
  end
end