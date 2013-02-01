class AddSelfCertToLicensedContractor < ActiveRecord::Migration
  def change
    add_column :licensed_contractors, :self_certified, :boolean
    rename_column  :licensed_contractors, :licensee_business_name, :business_name
    rename_column  :licensed_contractors, :licensee_business_type, :license_type
    rename_column  :licensed_contractors, :licensee_full_name, :full_name
    rename_column  :licensed_contractors, :licensee_HIC_number, :his_license_number
    rename_column  :licensed_contractors, :licensee_number, :license_number
    rename_column  :licensed_contractors, :licensee_phone, :phone
    rename_column  :licensed_contractors, :licensee_recent_filing_date, :recent_filing_date
  end
end
