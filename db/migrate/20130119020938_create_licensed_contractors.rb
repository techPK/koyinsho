class CreateLicensedContractors < ActiveRecord::Migration
  def up
    create_table :licensed_contractors do |t|
      t.string :licensee_full_name
      t.string :licensee_business_name
      t.string :licensee_business_type
      t.string :licensee_number
      t.string :licensee_HIC_number
      t.string :licensee_phone
      t.date  :licensee_recent_filing_date

      t.timestamps
    end
  end
  def down
    drop_table :licensed_contractors
  end
end
