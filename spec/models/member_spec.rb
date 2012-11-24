require 'spec_helper'

describe Member do
  it "has a valid factory" do
  	FactoryGirl.create(:member).should be_valid
  end	
  
  it "must be invalid when missing a first name" do
    FactoryGirl.build(:member, first_name:nil).should_not be_valid
  end

  it "must be invalid when missing a last name"  do
    FactoryGirl.build(:member, last_name:nil).should_not be_valid
  end

  it "must be invalid when last name starts with comma"  do
    FactoryGirl.build(:member, last_name:' , Wrong').should_not be_valid
  end

  it "must have an email address with valid email format" do
    FactoryGirl.build(:member, email:nil).should_not be_valid
    FactoryGirl.build(:member, email:"one.com").should_not be_valid
    FactoryGirl.build(:member, email:"one@.com").should_not be_valid
  end

  it "must have an email address that is unique in table" do
    FactoryGirl.create(:member, email:'bluefox@fox.com').should be_valid
    FactoryGirl.build(:member, email:'bluefox@fox.com').should_not be_valid
  end

  xit "must complete successfully"

  xit "must have a member_kind"
end
