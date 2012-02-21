require 'spec_helper'

describe IssuesController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.should have_selector("title", :content => "Manage Issues")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before (:each) do
        @attr = { :description => "" }
      end

      it "should not create a issue" do
        lambda do
          post :create, :issue => @attr
        end.should_not change(Issue, :count)
      end

      it "should have the right title" do
        post :create, :issue => @attr
        response.should have_selector("title", :content => "Manage Issues")
      end

      it "should render the 'index' page" do
        post :create, :issue => @attr
        response.should render_template("index")
      end
    end
  end

end
