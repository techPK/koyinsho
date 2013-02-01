require 'spec_helper'

describe PropertyBuilding do

  it 'should have bin defined' do
  	subject.attribute_names.include?('bin').should eq(true)
  end
  it 'should have recent_filing_date defined' do
  	subject.attribute_names.include?('recent_filing_date').should eq(true)
  end

  it 'should have many permits' do
  	PropertyBuilding.reflect_on_association(:permits).macro.should eq(:has_many)
  end
  it "has a valid factory" do
  	FactoryGirl.create(:property_building).should be_valid
  end 
end

describe "PropertyBuilding#borough_check" do
  it "must return nil when parameters all reference same borough" do
  	PropertyBuilding.borough_check('Manhattan', '10001', '101').should be_nil
  	PropertyBuilding.borough_check('Bronx', '10401', '201').should be_nil
  	PropertyBuilding.borough_check('Brooklyn', '11201', '301').should be_nil
  	PropertyBuilding.borough_check('Queens', '11101', '401').should be_nil
  	PropertyBuilding.borough_check('Staten Island', '10301', '501').should be_nil
  end

  it "must return error-text when parameters do not reference same borough" do
  	PropertyBuilding.borough_check('Manhattan', '10301', '301').should_not be_nil
  	PropertyBuilding.borough_check('Brooklyn', '10301', '301').should_not be_nil
  	PropertyBuilding.borough_check('Manhattan', '10001', '301').should_not be_nil
  end
end
 
describe "PropertyBuilding#search_for_contractors must return proper permit rows when selecting specific" do
  before(:each)	do
  	FactoryGirl.create(:property_building,
  		block:'510', lot:'00230')
  	FactoryGirl.create(:property_building,
  		block:'323', lot:'00230',
  		street_name:"Aloha Way",zip_code:'11238')
  	FactoryGirl.create(:property_building,
  		borough:'Bronx')
  	FactoryGirl.create(:property_building,
  		community_board:'407',
  		block:'510',lot:'00231')
  end

  it "block" do
  	value = "510"
  	search_params={:block.to_s => value}
  	properties = PropertyBuilding.where(search_params)
		properties.should_not be_nil
		properties.count.should eq(2)
		properties[0].block.should eq(value)
		properties[1].block.should eq(value)
  end

  it "lot" do
  	value = "00230"
  	search_params={:block.to_s => '510', :lot.to_s => value}
  	properties = PropertyBuilding.where(search_params)
	properties.count.should eq(1)
	properties[0].lot.should eq(value)
  end
  
  it "street" do
  	value = "Aloha Way"
  	search_params={:street_name.to_s => value}
  	properties = PropertyBuilding.where(search_params)
  	properties.count.should eq(1)
	properties[0].street_name.should eq(value)
  end
 
  it "community board" do
  	value = "407"
  	search_params={:community_board.to_s => value}
  	properties = PropertyBuilding.where(search_params)
  	properties.count.should eq(1)
	properties[0].community_board.should eq(value)
  end
 
  it "borough" do
  	value = "Bronx"
  	search_params={:borough.to_s => value}
  	properties = PropertyBuilding.where(search_params)
  	properties.count.should eq(1)
	properties[0].borough.should eq(value)
  end
 
  it "zip_code" do
  	value = "11238"
  	search_params={:zip_code.to_s => value}
  	properties = PropertyBuilding.where(search_params)
  	properties.count.should eq(1)
	properties[0].zip_code.should eq(value)
  end

end