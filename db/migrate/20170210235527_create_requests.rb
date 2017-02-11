class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :user
      t.references :organization
      t.text       :description,  null: false
      t.text       :purpose,      null: false
      t.string     :urgency,      null: false

      t.timestamps
    end

    add_index :requests, [:user_id, :organization_id]
  end
end
