class AddBinToPropertyOwner < ActiveRecord::Migration
  def change
    add_column :property_owners, :bin, :string
    add_column :licensed_contractors, :bin, :string
  end
end
