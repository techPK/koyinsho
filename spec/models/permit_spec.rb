require 'spec_helper'

describe Permit do
  it "has a valid factory" do
  	FactoryGirl.create(:permit).should be_valid
  end 
  
  it "must have unique job_number" do
  	FactoryGirl.create(:permit, permit_job_number:'090909').should be_valid
  	FactoryGirl.build(:permit, permit_job_number:'090909').should_not be_valid
  end

  it "must belong to a property" do
    Permit.reflect_on_association(:property_building).macro.should eq(:belongs_to)
  end
 
  it "must have associated Property attributes" do
    permit = FactoryGirl.create(:permit)
    permit.property_building.bin.should be_present
    permit.property_building.block.should be_present
    permit.property_building.lot.should be_present
    permit.property_building.borough.should be_present
    permit.property_building.street_name.should be_present
    permit.property_building.zip_code.should be_present
  end

  it "must belong to a licensed_contractor" do
    Permit.reflect_on_association(:licensed_contractor).macro.should eq(:belongs_to)
  end

  it "must have associated Licensed Contractor attributes" do
    permit = FactoryGirl.create(:permit)
    permit.licensed_contractor.bin.should be_present
    permit.licensed_contractor.full_name.should be_present
    permit.licensed_contractor.business_name.should be_present
    permit.licensed_contractor.license_type.should be_present
    permit.licensed_contractor.phone.should be_present
    permit.licensed_contractor.recent_filing_date.should be_present
  end


end

describe "Permit#search_for_contractors" do

  before(:each)	do
  	permit1 = FactoryGirl.create(:permit)
    permit1.licensed_contractor.full_name = 'Ed, Amy'
    permit1.licensed_contractor.save

  	permit2 = FactoryGirl.create(:permit)
    permit2.licensed_contractor.full_name = 'Um, Mai'
    permit2.licensed_contractor.save

  	permit3 = FactoryGirl.create(:permit,
  		permit_kind:"EW",permit_subkind:"QZ")
    permit3.licensed_contractor.full_name = 'Bi, Moe'
    permit3.licensed_contractor.save

  	permit4 = FactoryGirl.create(:permit)
    permit4.licensed_contractor.full_name = 'Mu, Joe'
    permit4.licensed_contractor.license_type = "MASTER PLANTER"
    permit4.licensed_contractor.save

  end

 
  it "must return permit rows in the specified order" do
  	search_params={:sort_by.to_s => "Licensee"}
  	contractors = LicensedContractor.search(search_params)
  	contractors.should_not be_nil
  	contractors.count.should eq(4)
  	contractors[0].full_name.should eq('Bi, Moe')
  	contractors[1].full_name.should eq('Ed, Amy')
  	contractors[2].full_name.should eq('Mu, Joe')
  	contractors[3].full_name.should eq('Um, Mai')
  end

  it "license type" do
  	value = "MASTER PLANTER"
  	search_params={:license_type.to_s => value}
  	contractors = LicensedContractor.search(search_params)
  	contractors.count.should eq(1)
		contractors[0].license_type.should eq(value)
  end

  it "permit type" do
  	value = "EW/QZ"
    search_params = {:work_type.to_s => value}	  	
  	contractors = LicensedContractor.search(search_params)
  	contractors.count.should eq(1)
	  contractors[0].full_name.should eq('Bi, Moe')
  end

end
 
describe "Permit.create_or_update_permit" do

  before(:each) do
    @old_permit = FactoryGirl.attributes_for(
                    :permit,
                    permit_job_number:"0101010101",
                    permit_issuance_date:(Date.today - 100)
                  )
    permit_old = FactoryGirl.create(:permit, @old_permit)
    permit_old.licensed_contractor.full_name = 'Richards, Sue'
    permit_old.licensed_contractor.save
  end

  it "must add new record when given new permit_job_number" do
    expect {
      new_permit = @old_permit
      new_permit[:permit_job_number] = "0202020202"
      Permit.create_or_update_permit(new_permit).should be_nil
    }.to change(Permit, :count).by(1)
  end
  
  it "must update old record when given existing permit_job_number and newer permit_issuance_date" do
    new_permit = @old_permit
    new_permit[:permit_issuance_date] = Date.today - 2
    expect {
      Permit.create_or_update_permit(new_permit).should be_nil
    }.to change(Permit, :count).by(0)
    current_permit = Permit.where(permit_job_number:new_permit[:permit_job_number]).first
    current_permit.permit_issuance_date.should eq(Date.today - 2)
  end

  it "must do nothing when given existing permit_job_number with older permit_issuance_date" do
    expect {
      new_permit = @old_permit
      new_permit[:permit_issuance_date] = Date.today - 200
      Permit.create_or_update_permit(new_permit).should be_nil
    }.to change(Permit, :count).by(0)
  end  

  it "must return text message when given permit is found invalid or inacceptable for being saved" do
    new_permit = @old_permit
    new_permit[:permit_issuance_date] = "Not a valid date format"
    Permit.create_or_update_permit(new_permit).should_not be_nil
  end
end
