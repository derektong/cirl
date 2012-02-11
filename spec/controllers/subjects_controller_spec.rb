require 'spec_helper'

describe SubjectsController do
  render_views

  describe "GET 'list'" do
    it "should be successful" do
      get 'list'
      response.should be_success
    end

    it "should have the right title" do
      get 'list'
      response.should have_selector("title", :content => "Manage Subjects")
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

end
