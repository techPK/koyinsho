require 'spec_helper'

describe "members/new" do
  before(:each) do
    assign(:member, stub_model(Member,
      :email => "MyString",
      :visits => 1,
      :name_full => "MyString"
    ).as_new_record)
  end

  it "renders new member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => members_path, :method => "post" do
      assert_select "input#member_email", :name => "member[email]"
      assert_select "input#member_visits", :name => "member[visits]"
      assert_select "input#member_name_full", :name => "member[name_full]"
    end
  end
end
