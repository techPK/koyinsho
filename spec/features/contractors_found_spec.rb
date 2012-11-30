require 'spec_helper'
include Capybara::DSL

describe "Contractors-found webpage" do
	it "must not appear if search results are zero" do
		visit "/searches"
		click_button('Find Contractors')
		click_button('Find Contractors')
		uri = URI.parse(current_url)
		uri.path.should == '/searches'
		page.should have_xpath "/html/head[title='Koyinsho | Search']"
	end

	it "must appear if search results are one or more" do
		FactoryGirl.create(:permit)
		visit "/searches"
		click_button('Find Contractors')
		click_button('Find Contractors')
		uri = URI.parse(current_url)
		uri.path.should == '/searches/contractors'
		page.should have_xpath "/html/head[title='Koyinsho | Search | Contractors']"
	end
end