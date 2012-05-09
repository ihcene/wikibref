class AddImagesToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :images, :text
  end
end
