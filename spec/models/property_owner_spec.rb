require 'spec_helper'

describe PropertyOwner do

  it "has a valid factory" do
  	FactoryGirl.create(:property_owner).should be_valid
  end 

  it "must have_many properties relationship" do
    PropertyOwner.reflect_on_association(:property_buildings).macro.should eq(:has_many)
  end

  it 'should have bin defined' do
  	subject.attribute_names.include?('bin').should eq(true)
  end
end
