class AddCategoryIdToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :category_id, :integer
    add_index :articles, :category_id
  end
end
