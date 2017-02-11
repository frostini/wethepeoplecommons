class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.references :visitor
      t.string :email,            null: false
      t.string :password_digest,  null: false
      t.string :first_name,       null: false
      t.string :last_name,        null: false
      t.string :phone


      t.timestamps null: false
    end

    add_index :users, :email,      unique: true
    add_index :users, :visitor_id, unique: true
  end
end
