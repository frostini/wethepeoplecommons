class CreateSkillJoins < ActiveRecord::Migration
  def change
    create_table :skill_joins do |t|
      t.references :skill, null: false
      t.integer    :skillable_id, null: false
      t.string     :skillable_type, null: false

      t.timestamps
    end

    add_index :skill_joins, [:skillable_id, :skillable_type]
    add_index :skill_joins, :skill_id
  end
end
