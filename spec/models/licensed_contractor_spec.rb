require 'spec_helper'

describe LicensedContractor do
  it 'should have bin defined' do
  	subject.attribute_names.include?('bin').should eq(true)
  end
end

describe "LicensedContractor#search" do
  it "must find correct data" do
  	property = FactoryGirl.create(:property_building, zip_code:'10019')
	contractor1 = FactoryGirl.create(:licensed_contractor, license_number:'0002660')
	FactoryGirl.create(:permit,property_building:property,licensed_contractor:contractor1, permit_kind:'EW')
  	
	contractor2 = FactoryGirl.create(:licensed_contractor, license_number:'0002661')
	FactoryGirl.create(:permit,property_building:property,licensed_contractor:contractor2, permit_kind:'OT')
	
	contractor3 = FactoryGirl.create(:licensed_contractor, license_number:'0052660')
	FactoryGirl.create(:permit,property_building:property,licensed_contractor:contractor3, permit_kind:'EW')

  	search_params={permit_type:'OT',zipcode:'10019'}
  	LicensedContractor.search(search_params).first.should eq(contractor2)
  end

end
