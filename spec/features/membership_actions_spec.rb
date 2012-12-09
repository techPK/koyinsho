require 'spec_helper'
# include Capybara::DSL

describe "Membership Sign-up" do
  before(:each) do
  	visit "/signup"
  end

  context "form" do
  	it "must have First name" do
  		fill_in "First name", with:"Fred"
  	end
  	it "must have last name" do
  		fill_in "Last name", with:"Flintstone"
  	end
  	it "must have email" do
  		fill_in "Email", with:"Fred.Flintstone@yabadaba.do"
  	end
  	xit "must have roles Owner, Agent, Contractor, Supplier" do
  	end
  	it "must have password & password repeat" do
  		fill_in "Password confirmation", with:"Fred"
      fill_in "Password", with:"Wilma"
  	end
  	it "must have a submit button" do
  		click_button "Request Membership"
  	end	
  end
end