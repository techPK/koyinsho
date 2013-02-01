class AddAssociationsToPermit < ActiveRecord::Migration
  def change
    add_column :permits, :property_building_id, :integer
  end
end
