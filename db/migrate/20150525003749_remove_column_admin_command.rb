class RemoveColumnAdminCommand < ActiveRecord::Migration
  def change
	remove_column :commands, :admin
  end

  def down
	add_column :commands, :admin, :boolean, default: true
  end
end
