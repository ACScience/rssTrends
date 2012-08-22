class CreateTrends < ActiveRecord::Migration
  def change
    create_table :trends do |t|
      t.string :trendy_word
      t.integer :counter, :default => 1

      t.timestamps
    end
  end
  
  def down
      drop_table :trends if ActiveRecord::Base.connection.table_exists? 'trends'
  end
end
