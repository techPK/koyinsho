require 'spec_helper'
include Capybara::DSL

describe "menu items" do
  before(:each) do 
    visit "/" #root
   end

  it "must have 'About' among them on root" do
  	click_link 'About'
  end
  
  it "must have 'Contact' among them on root" do
  	click_link 'Contact'
  end

  xit "must have 'FAQ' among them on root" do
  	click_link 'FAQ'
  end

  it "must have 'Koyinsho' among them on root" do
  	page.should have_link('Koyinsho')
  end

  xit "must have 'Learn' among them on root" do
  	click_link 'Learn'
  end

  xit "must have 'Search' among them on root" do
  	click_link 'Search'
  end

  it "must have 'Sign-in' or 'Sign-out' among them" do
  	click_link 'Sign-in'
  end

end
