class CreateInformationVersions < ActiveRecord::Migration
  def change
    create_table :information_versions do |t|
      t.references  :information
      t.text        :content
      t.datetime    :until
      t.references  :author

      t.timestamps
    end
  end
end
