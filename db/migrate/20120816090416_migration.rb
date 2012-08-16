class Migration < ActiveRecord::Migration
  def up
      add_column :feed_entries, :processed, :boolean, :default => false
  end

  def down
      remove_column :feed_entries, :processed
  end
end

