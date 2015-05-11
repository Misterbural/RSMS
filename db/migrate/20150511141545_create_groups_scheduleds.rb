class CreateGroupsScheduleds < ActiveRecord::Migration
  def change
    create_table :groups_scheduleds do |t|
      t.integer :scheduled_id
      t.integer :group_id

      t.timestamps null: false
    end
  end
end
