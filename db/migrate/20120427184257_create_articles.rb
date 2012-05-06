class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :lang_code
      t.string :image_uri

      t.timestamps
    end
  end
end
