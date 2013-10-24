class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.text :overview
      t.integer :series_id

      t.timestamps
    end
  end
end
