class ChangeColumnNameToDigest < ActiveRecord::Migration
  def up
    rename_column :authors, :password_salt, :password_digest
  end

  def down
    rename_column :authors, :password_digest, :password_salt
  end
end
