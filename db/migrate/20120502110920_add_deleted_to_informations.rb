class AddDeletedToInformations < ActiveRecord::Migration
  def change
    add_column :informations, :deleted, :boolean, :default => false
  end
end
