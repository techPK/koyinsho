class AddPermitIssuanceDateToPermit < ActiveRecord::Migration
  def up
    add_column :permits, :permit_issuance_date, :date
    remove_column :permits, :permit_expiration_date
  end
  def down
    remove_column :permits, :permit_issuance_date
    add_column :permits, :permit_expiration_date, :string  	
  end
end
