class CreateInformation < ActiveRecord::Migration
  def change
    create_table :information do |t|
      t.reference :article
      t.text :content
      t.integer :score
      t.reference :last_revision_author
      t.boolean :is_main

      t.timestamps
    end
  end
end
