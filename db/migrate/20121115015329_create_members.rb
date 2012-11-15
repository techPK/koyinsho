class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :email
      t.integer :visits
      t.string :name_full

      t.timestamps
    end
  end
end
