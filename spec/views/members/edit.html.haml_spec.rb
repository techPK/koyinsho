require 'spec_helper'

describe "members/edit" do
  before(:each) do
    @member = assign(:member, stub_model(Member,
      :email => "MyString",
      :visits => 1,
      :name_full => "MyString"
    ))
  end

  it "renders the edit member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => members_path(@member), :method => "post" do
      assert_select "input#member_email", :name => "member[email]"
      assert_select "input#member_visits", :name => "member[visits]"
      assert_select "input#member_name_full", :name => "member[name_full]"
    end
  end
end
