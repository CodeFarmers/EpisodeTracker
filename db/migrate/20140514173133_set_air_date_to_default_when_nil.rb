class SetAirDateToDefaultWhenNil < ActiveRecord::Migration
  def change
    episodes_without_air_date = Episode.where(air_date: nil)
    episodes_without_air_date.each do |episode|
      episode.air_date = '01/01/2100'.to_date
      episode.save
    end
  end
end
