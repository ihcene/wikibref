class CreateArticleVersions < ActiveRecord::Migration
  def change
    create_table :article_versions do |t|
      t.boolean     :reorder, :reload_images, :change_image
      t.references  :article, :information, :author
      
      t.text        :content

      t.timestamps
    end
  end
end
