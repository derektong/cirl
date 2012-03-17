require 'spec_helper'

describe child_topicsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.should have_selector("title", :content => "Manage child_topics")
    end
  end

  
  describe "POST 'create'" do
    describe "failure" do

      before (:each) do
        @attr = { :description => "" }
      end

      it "should not create a child_topic" do
        lambda do
          post :create, :child_topic => @attr
        end.should_not change(child_topic, :count)
      end

      it "should have the right title" do
        post :create, :child_topic => @attr
        response.should have_selector("title", :content => "Manage child_topics")
      end

      it "should render the 'index' page" do
        post :create, :child_topic => @attr
        response.should render_template("index")
      end
    end
  end

end
