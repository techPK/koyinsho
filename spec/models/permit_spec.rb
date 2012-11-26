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