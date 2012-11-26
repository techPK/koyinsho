class AddOwnerIsNonProfitToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :owner_is_non_profit, :boolean
  end
end
