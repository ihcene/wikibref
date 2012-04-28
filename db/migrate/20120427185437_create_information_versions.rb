class CreateInformationVersions < ActiveRecord::Migration
  def change
    create_table :information_versions do |t|
      t.reference :information
      t.text :content
      t.datetime :until
      t.reference :author

      t.timestamps
    end
  end
end
