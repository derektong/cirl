require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    it "should have the content 'CIRL'" do
      visit '/'
      page.should have_content('CIRL')
    end
  end

end
