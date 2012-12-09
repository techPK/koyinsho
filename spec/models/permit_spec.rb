require 'spec_helper'

describe Permit do
  it "has a valid factory" do
  	FactoryGirl.create(:permit).should be_valid
  end 

  it "must have unique job_number" do
  	FactoryGirl.create(:permit, permit_job_number:'090909').should be_valid
  	FactoryGirl.build(:permit, permit_job_number:'090909').should_not be_valid
  end
end

describe "Permit#borough_check" do
  it "must return nil when parameters all reference same borough" do
  	Permit.borough_check('Manhattan', '10001', '101').should be_nil
  	Permit.borough_check('Bronx', '10401', '201').should be_nil
  	Permit.borough_check('Brooklyn', '11201', '301').should be_nil
  	Permit.borough_check('Queens', '11101', '401').should be_nil
  	Permit.borough_check('Staten Island', '10301', '501').should be_nil
  end

  it "must return error-text when parameters do not reference same borough" do
  	Permit.borough_check('Manhattan', '10301', '301').should_not be_nil
  	Permit.borough_check('Brooklyn', '10301', '301').should_not be_nil
  	Permit.borough_check('Manhattan', '10001', '301').should_not be_nil
  end
end

describe "Permit#search_for_contractors" do

  before(:each)	do
  	FactoryGirl.create(:permit,licensee_full_name:'Ed, Amy',
  		property_block_number:'510', property_lot_number:'00230')
  	FactoryGirl.create(:permit,licensee_full_name:'Um, Mai',
  		property_block_number:'323', property_lot_number:'00230',
  		property_street:"Aloha Way",property_zipcode:'11238')
  	FactoryGirl.create(:permit,licensee_full_name:'Bi, Moe',
  		property_borough:'Bronx', permit_kind:"EW",permit_subkind:"QZ")
  	FactoryGirl.create(:permit,licensee_full_name:'Mu, Joe',
  		property_block_number:'510',property_lot_number:'00231',
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
end

describe "Permit#search_for_contractors must return proper permit rows when selecting specific" do
  before(:each)	do
  	FactoryGirl.create(:permit,licensee_full_name:'Ed, Amy',
  		property_block_number:'510', property_lot_number:'00230')
  	FactoryGirl.create(:permit,licensee_full_name:'Um, Mai',
  		property_block_number:'323', property_lot_number:'00230',
  		property_street:"Aloha Way",property_zipcode:'11238')
  	FactoryGirl.create(:permit,licensee_full_name:'Bi, Moe',
  		property_borough:'Bronx', permit_kind:"EW",permit_subkind:"QZ")
  	FactoryGirl.create(:permit,licensee_full_name:'Mu, Joe',
  		property_community_district_number:'407',
  		property_block_number:'510',property_lot_number:'00231',
  		licensee_license_kind:"MASTER PLANTER")
  end

  it "block" do
  	value = "510"
  	search_params={:block.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
		permits.should_not be_nil
		permits.count.should eq(2)
		permits[0].property_block_number.should eq(value)
		permits[1].property_block_number.should eq(value)
  end

  it "lot" do
  	value = "00230"
  	search_params={:block.to_s => '510', :lot.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
	permits.count.should eq(1)
	permits[0].property_lot_number.should eq(value)
  end
  

  it "street" do
  	value = "Aloha Way"
  	search_params={:street.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
	  permits[0].property_street.should eq(value)
  end

  it "community district" do
  	value = "407"
  	search_params={:community_district.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
	  permits[0].property_community_district_number.should eq(value)
  end
  
  it "license type" do
  	value = "MASTER PLANTER"
  	search_params={:license_type.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
		permits[0].licensee_license_kind.should eq(value)
  end

  it "borough" do
  	value = "Bronx"
  	search_params={:borough.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
		permits[0].property_borough.should eq(value)
  end
  
  it "permit type" do
  	value = "EW/QZ"
    search_params = {:permit_type.to_s => value}	  	
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
	permits[0].permit_kind.should eq(value[0,2])
	permits[0].permit_subkind.should eq(value[3,2])
  end
  
  it "zipcode" do
  	value = "11238"
  	search_params={:zipcode.to_s => value}
  	permits = Permit.search_for_contractors(search_params)
  	permits.count.should eq(1)
	permits[0].property_zipcode.should eq(value)
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
