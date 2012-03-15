require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the title 'CIRL'" do
      visit '/'
      page.should have_selector('title', 'CIRL')
    end
  end

end
