class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :password_salt

      t.timestamps
    end
  end
end
