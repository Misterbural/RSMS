class CreateSendeds < ActiveRecord::Migration
  def change
    create_table :sendeds do |t|
      t.string :target, null: false
      t.text :content, null: false

      t.timestamps null: false
    end
  end
end
