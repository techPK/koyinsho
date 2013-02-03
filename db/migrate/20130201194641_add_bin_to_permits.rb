class AddBinToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :bin, :string
  end
end
