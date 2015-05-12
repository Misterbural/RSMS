class CreateGroupsScheduleds < ActiveRecord::Migration
  def change
    create_table :groups_scheduleds do |t|
      t.belongs_to :scheduled
      t.belongs_to :group
    end
  end
end
