class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type, limit: 25, :null => false
      t.string :text, limit: 255, :null => false

      t.timestamps null: false
    end
  end
end
