class Series < ActiveRecord::Base

  has_many :episodes, :dependent => :destroy, :primary_key=> "remote_id"

  attr_accessible :name, :overview, :remote_id, :last_remote_update
  validates :name, presence: true, uniqueness: true

  def self.search(search)
    if search
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

  def needs_update?
    ac = ApiConnector.new
    previous_time = self.last_remote_update
    updates = ac.retrieve_updates(previous_time)
    updates = REXML::Document.new(updates)

    updatable_series = []
    updates.elements.each('//Series') do |element|
      updatable_series << element.text().to_i
    end

    updatable_series.include?(self.remote_id)
  end
end