class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :email, null: false
      t.string :type,  null: false

      t.timestamp null: false
    end

    add_index :visitors, [:email, :type],     unique: true
  end
end
