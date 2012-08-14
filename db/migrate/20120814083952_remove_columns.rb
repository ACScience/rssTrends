class RemoveColumns < ActiveRecord::Migration
  def up
  remove_column :feed_entries, :guid
  end

  def down
  end
end
