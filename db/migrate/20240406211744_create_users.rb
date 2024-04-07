class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :public_key

      t.timestamps
    end

    add_index :users, :email
  end
end
