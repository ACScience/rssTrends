class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :feed_entry_id
      t.integer :trend_id
     # t.text :trendy_word
     # t.integer :trend_counter
     # t.string :feed_name
     # t.text :feed_text
     # t.string :feed_url
     # t.datetime :published_at
     # t.datetime :created_at
     # t.datetime :updated_at

      t.timestamps
    end
  end
end
