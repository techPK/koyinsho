require 'spec_helper'
# include Capybara::DSL

describe "Searches" do
	context "webpage" do
		before(:each) do
			visit "/searches"
		end

		it "must allow selection of 'Borough'" do
			#find_field('Borough').find('option')
			select('Bronx', :from => 'Borough')
			select 'Brooklyn'
			select 'Manhattan'
			select 'Queens'
			select 'Staten Island'
		end

		it "must allow entry of 'Block'" do
			fill_in 'Block', with:'1000'
		end

		xit "must allow entry of 'Lot'" do
			fill_in 'Lot', with:'9999'
		end

		it "must allow entry of 'Zipcode'" do
			fill_in 'Zipcode', with:'10001'
		end

		it "must allow entry of 'Street'" do
			fill_in 'Street', with:'Broadway'
		end

		xit "must allow entry of 'Address-Number'" do
			fill_in 'Address-Number', with:'1111'
		end

		it "must allow entry of 'Community District'" do
			fill_in 'Community district', with:'101'
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
			select 'Licensee'
            select 'License-Type'
            select 'Business-Name'
            select 'Permit-Count'
		end
 
		it "must allow entry of 'work_type'" do
            page.should have_xpath "//select[@name='work_type']"
            page.should have_xpath "//select[@name='work_type']/optgroup"
            page.should have_xpath "//select[@name='work_type']/optgroup[@label='ALTERATION']/option[@value='AL']"
            page.should have_xpath "//select[@name='work_type']/optgroup[@label='DEMOLITION & REMOVAL']/option[@value='DM']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='New Building']/option[@value='NB']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='PLUMBING']/option[@value='PL']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='SIGN']/option[@value='SG']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='CONSTRUCTION EQUIPMENT']/option[@value='EQ']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='CONSTRUCTION EQUIPMENT']/option[@value='EQ/CH']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='CONSTRUCTION EQUIPMENT']/option[@value='EQ/FN']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='CONSTRUCTION EQUIPMENT']/option[@value='EQ/OT']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='CONSTRUCTION EQUIPMENT']/option[@value='EQ/SF']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EQ/SH']"
            page.should have_xpath "//select[@name='work_type']/optgroup[@label='EQUIPMENT WORK']/option[@value='EW']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/BL']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/FA']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/FB']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/FP']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/FS']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/MH']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/OT']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/SD']"
			page.should have_xpath "//select[@name='work_type']//option[@value='EW/SP']"
			page.should have_xpath "//select[@name='work_type']/optgroup[@label='FOUNDATION/EARTHWORK']/option[@value='FO']"
			page.should have_xpath "//select[@name='work_type']//option[@value='FO/EA']"
		end
	end

	context "for all visitors" do
		before(:each) do
			visit "/searches"
		end

		it "must have a button for 'Find Contractors'" do
			page.should have_button('Find Contractors')
		end

		it "must have a button for 'Find Agents'" do
			page.should have_button('Find Agents')
		end

		it "must have a button for 'Find Suppliers'" do
			page.should have_button('Find Suppliers')
		end
	end

	context "for all non-signed-in visitors" do
		it "must NOT have a 'Find Owners' button" do
			page.should_not have_button('Find Owners')
		end
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
			xit "must NOT have a 'Find Owners' button" do
				page.should_not have_button('Find Owners')
			end
		end		

		describe "Agents" do
			xit "must have a button for 'Find Owners'" do
				page.should have_button('Find Owners')
			end
		end

		describe "Contractors" do
			xit "must have a button for 'Find Owners'" do
				page.should have_button('Find Owners')
			end	
		end

		describe "Suppliers" do
			xit "must have a button for 'Find Owners'"	do
				page.should have_button('Find Owners')
			end
		end

		it "must give error when Block is given without Borough" do
		  fill_in 'Block', with:'1000'
		  # click_button "Find Contractors"
		  find_by_id('contractors').click
		  uri = URI.parse(current_url)
		  uri.path.should == '/searches'
		  page.should have_xpath "/html/head[title='Koyinsho | Search']"
		end

		xit "must give error when Lot is given without Block"  do
		  fill_in 'Lot', with:'91000'
		  click_button('Find Contractors')
		  uri = URI.parse(current_url)
		  uri.path.should == '/searches'
		  page.should have_xpath "/html/head[title='Koyinsho | Search']"
		end

	end
end