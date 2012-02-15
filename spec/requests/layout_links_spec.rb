require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    visit root_path
    page.should have_selector('title', :text =>"CIRL | Home")
  end



end
