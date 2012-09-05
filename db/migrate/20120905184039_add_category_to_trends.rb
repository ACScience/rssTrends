class AddCategoryToTrends < ActiveRecord::Migration
  def change
    add_column :trends, :category, :string
  end
end
