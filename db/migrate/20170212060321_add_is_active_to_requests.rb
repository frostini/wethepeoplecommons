class AddIsActiveToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :is_active, :boolean, null: false, default: true, after: :urgency
  end
end
