require 'spec_helper'
include Capybara::DSL

describe "Searches" do


	context "webpage" do
		before(:each) do
			visit "/searches"
		end

		it "must allow selection of 'Borough'" do
			#find_field('Borough').find('option')
			select 'Bronx'
			select 'Brooklyn'
			select 'Manhattan'
			select 'Queens'
			select 'Staten Island'
		end

		it "must allow entry of 'Block'" do
			fill_in 'Block', with:'1000'
		end

		it "must allow entry of 'Lot'" do
			fill_in 'Lot', with:'9999'
		end

		it "must allow entry of 'Zipcode'" do
			fill_in 'Zipcode', with:'10001'
		end

		it "must allow entry of 'Street'" do
			fill_in 'Street', with:'Broadway'
		end

		it "must allow entry of 'Address-Number'" do
			fill_in 'Address-Number', with:'1111'
		end

		it "must allow entry of 'Community District'" do
			fill_in 'Community District', with:'101'
		end

		it "must allow selection of 'Licensee Type'" do
			select "ADMIN/NO WORK"
            select "DEMOLITION CONTRACTOR"
            # select "Electric CONTRACTOR"
            select "FIRE SUPPRESSION CONTRACTOR"
            select "GENERAL CONTRACTOR"
            select "HOME IMPROVEMENT CONTRACTOR"
            select "MASTER PLUMBER"
            select "OIL BURNER INSTALLER"
            select "OWNER"
            select "SIGN HANGER"
		end

		it "must allow selection of 'sort_by'" do
			select 'Permittee'
            select 'License-Type'
            select 'Business-Name'
            select 'Permit-Count'
		end

		xit "must allow entry of 'permit_type'" do
            select 'AL'
            select 'DM'
          #  select 'NB'
            select 'PL'
          #  select 'SG'
          #  select 'EQ'
          #  select 'EQ/CH'
          #  select 'EQ/FN'
          #  select 'EQ/OT'
            select 'EQ/SF'
            select 'EQ/SH'
            select 'EW'
            select 'EW/BL'
            select 'EW/FA'
            select 'EW/FB'
            select 'EW/FP'
            select 'EW/FS'
            select 'EW/MH'
            select 'EW/OT'
            select 'EW/SD'
            select 'EW/SP'
            select 'FO'
            select 'FO/EA'
		end
	end

	context "for all visitors" do
		xit "must have a button for 'Find Contractors'"
		xit "must have a button for 'Find Agents'"
		xit "must have a button for 'Find Suppliers'"	
	end

	context "for all non-signed-in visitors" do
		xit "must NOT have a 'Find Owners' button"
	end

	context "for signed-in" do
		before(:each) do
	      FactoryGirl.create(:member,email:'y.mike@micky.info')
	      visit "/signin"
	      fill_in('Email', with:'y.mike@micky.info')
	      fill_in('Password', with:'secret')
	      click_button('Sign in')
	      page.should have_content('Logged in!')
	      visit "/searches"		
		end

		describe "Owners" do
			xit "must NOT have a 'Find Owners' button"
		end		

		describe "Agents" do
			xit "must have a button for 'Find Owners'"	
		end

		describe "Contractors" do
			xit "must have a button for 'Find Owners'"	
		end

		describe "Suppliers" do
			xit "must have a button for 'Find Owners'"	
		end
	end
end