class Add < ActiveRecord::Migration
  def up
    change_table :articles do |t|
      t.references :creator
      t.references :last_modifier
    end
  end

  def down
    remove_column :articles, :creator
    remove_column :articles, :last_modifier
  end
end
