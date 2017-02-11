class CreateVolunteerProfiles < ActiveRecord::Migration
  def change
    create_table :volunteer_profiles do |t|
      t.references :user
      t.text       :bio
      t.text       :interest

      t.timestamps
    end

    add_index :volunteer_profiles, :user_id, unique: true
  end
end
