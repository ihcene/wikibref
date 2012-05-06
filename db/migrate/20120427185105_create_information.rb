class CreateInformation < ActiveRecord::Migration
  def change
    create_table :informations do |t|
      t.references    :article
      t.text          :content
      t.integer       :score
      t.references    :last_revision_author
      t.boolean       :is_main, :default => false
      
      t.string        :link_for_details

      t.timestamps
    end
  end
end
