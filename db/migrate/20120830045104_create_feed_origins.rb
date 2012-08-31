class CreateFeedOrigins < ActiveRecord::Migration
  def change
    create_table :feed_origins do |t|
      t.string :url
      t.string :category

      t.timestamps
    end
  end
end
