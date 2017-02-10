class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :email, null: false
      t.string :group,  null: false

      t.timestamps null: false
    end

    add_index :visitors, [:email, :group],     unique: true
  end
end
