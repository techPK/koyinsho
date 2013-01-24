class AddRecentFilingDateToPropertyOwner < ActiveRecord::Migration
  def change
    add_column :property_owners, :recent_filing_date, :date
  end
end
