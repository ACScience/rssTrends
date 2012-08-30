class CreateFeedAdresses < ActiveRecord::Migration
  def change
    create_table :feed_adresses do |t|
      t.string :url
      t.string :category

      t.timestamps
    end
  end
end
