require 'spec_helper'

describe "tournaments/new" do
  before(:each) do
    assign(:tournament, stub_model(Tournament,
      :user_id => 1,
      :name => "MyString",
      :active => false
    ).as_new_record)
  end

  it "renders new tournament form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tournaments_path, :method => "post" do
      assert_select "input#tournament_user_id", :name => "tournament[user_id]"
      assert_select "input#tournament_name", :name => "tournament[name]"
      assert_select "input#tournament_active", :name => "tournament[active]"
    end
  end
end
