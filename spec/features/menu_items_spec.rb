require 'spec_helper'
include Capybara::DSL

describe "menu items" do
  before(:each) do 
    visit "/" #root
   end

  it "must have 'Koyinsho' among them on root" do
    page.should have_link('Koyinsho')
  end

  context "must have 'Learn" do

    xit "' among them on root" do
      click_link 'Learn'
    end

    it "/ Amazon' among them on root" do
      click_link 'Amazon'
    end

    it "/ Disqus' among them on root" do
      click_link 'Disqus'
    end
  end

  context "must have 'Search /" do
    it "Owners' among them on root" do
      click_link 'Owners'
    end

    it "Agents' among them on root" do
      click_link 'Agents'
    end

    it "Contractors' among them on root" do
      click_link 'Contractors'
    end

    it "Suppliers' among them on root" do
      click_link 'Suppliers'
    end
  end

  it "must have 'About' among them on root" do
  	click_link 'About'
  end
 
  xit "must have 'FAQ' among them on root" do
    click_link 'FAQ'
  end

  it "must have 'Contact' among them on root" do
  	click_link 'Contact'
  end

  it "must have 'Dashboard' among them on root" do
    click_link 'Dashboard'
  end


  context "must have 'Membership" do

    xit "must have 'Membership' among them on root" do # unable to make a working test for this!!!
      # page.should have_link('mLabel9')
      click_link 'Membership'
    end

    it "/ Sign-in' among them on root" do
      click_link 'Sign-in'
    end

    it "/ Sign-up' among them on root" do
      click_link 'Sign-up'
    end

    it "/ Sign-out' among them on root" do
      click_link 'Sign-out'
    end

    it "/ Account' among them on root" do
      click_link 'Account'
    end
  end

end
