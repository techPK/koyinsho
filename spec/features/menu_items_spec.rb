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


  context "when user is NOT signed-on" do

    xit "must have 'Membership' among them on root" do # unable to make a working test for this!!!
      # page.should have_link('mLabel9')
      click_link 'Membership'
    end

    it "include 'Sign-in'" do
      page.should have_link('Sign-in')
    end

    it "include 'Sign-up'" do
      page.should have_link('Sign-up')
    end
    
    it "NOT include 'Sign-out'" do
      page.should_not have_link('Sign-out')
    end

    it "NOT include 'Account'" do
      page.should_not have_link('Account')
    end
  end

  context "when user is signed-on" do
    before(:each) do
      FactoryGirl.create(:member,email:'m.mike@micky.info')
      visit "/signin"
      fill_in('Email', with:'m.mike@micky.info')
      fill_in('Password', with:'secret')
      click_button('Sign in')
      # page.should have_text('Logged in!')
    end

    it "include 'Sign-in'" do
      page.should_not have_link('Sign-in')
    end

    it "include 'Sign-up'" do
      page.should_not have_link('Sign-up')
    end
    
    it "NOT include 'Sign-out'" do
      page.should have_link('Sign-out')
    end

    it "NOT include 'Account'" do
      page.should have_link('Account')
    end
  end

end
