class RemoveLicenseeOtherTitleFromPermits < ActiveRecord::Migration
  def up
    remove_column :permits, :licensee_other_title
  end

  def down
    add_column :permits, :licensee_other_title, :string
  end
end
