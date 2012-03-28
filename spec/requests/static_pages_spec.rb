require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the title 'CIRL'" do
      visit root_path
      page.should have_selector('title', text: full_title('') )
    end
  end

  describe "About" do
    it "should have the title 'about'" do
      visit '/about'
      page.should have_selector('title', text: full_title('About') )
    end
  end

end
