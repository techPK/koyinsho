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
  	FactoryGirl.create(:permit,licensee_full_name:'Ed, Amy')
  	FactoryGirl.create(:permit,licensee_full_name:'Um, Mai')
  	FactoryGirl.create(:permit,licensee_full_name:'Bi, Moe',
  		permit_kind:"EW",permit_subkind:"QZ")
  	FactoryGirl.create(:permit,licensee_full_name:'Mu, Joe',
  		licensee_license_kind:"MASTER PLANTER")
  end


  xit "must return permit rows in the specified order" do
  	search_params={:sort_by.to_s => "Contractor"}
  	permits = Permit.search_for_contractors(search_params)
  	permits.should_not be_nil
  	permits.count.should eq(4)
  	permits[0].licensee_full_name.should eq('Bi, Moe')
  	permits[1].licensee_full_name.should eq('Ed, Amy')
  	permits[2].licensee_full_name.should eq('Mu, Joe')
  	permits[3].licensee_full_name.should eq('Um, Mai')
  end

  it "license type" do
  	value = "MASTER PLANTER"
  	search_params={:license_type.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
		permits[0].licensee_license_kind.should eq(value)
  end

  it "permit type" do
  	value = "EW/QZ"
    search_params = {:permit_type.to_s => value}	  	
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
	  permits[0].permit_kind.should eq(value[0,2])
	  permits[0].permit_subkind.should eq(value[3,2])
  end

end

describe "Permit.create_or_update_permit" do

  before(:each) do
    @old_permit = FactoryGirl.attributes_for(
                    :permit,
                    licensee_full_name:'Richards, Sue', 
                    permit_job_number:"0101010101",
                    permit_issuance_date:(Date.today - 100)
                  )
    FactoryGirl.create(:permit, @old_permit)
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
