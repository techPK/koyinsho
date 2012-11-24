require 'spec_helper'

describe "members/index" do
  before(:each) do
    assign(:members, [
      stub_model(Member,
        :email => "Email",
        :visits => 1,
        :name_full => "Name Full"
      ),
      stub_model(Member,
        :email => "Email",
        :visits => 1,
        :name_full => "Name Full"
      )
    ])
  end

  xit "renders a list of members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name Full".to_s, :count => 2
  end
end
