require 'spec_helper'

describe CourtsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.should have_selector("title", :content => "Manage Courts")
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

end
