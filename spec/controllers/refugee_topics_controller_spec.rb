require 'spec_helper'

describe refugee_topicsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.should have_selector("title", :content => "Manage refugee_topics")
    end
  end

  describe "POST 'create'" do

    describe "failure" do

      before (:each) do
        @attr = { :description => "" }
      end

      it "should not create a refugee_topic" do
        lambda do
          post :create, :refugee_topic => @attr
        end.should_not change(refugee_topic, :count)
      end

      it "should have the right title" do
        post :create, :refugee_topic => @attr
        response.should have_selector("title", :content => "Manage refugee_topics")
      end

      it "should render the 'index' page" do
        post :create, :refugee_topic => @attr
        response.should render_template("index")
      end
    end
  end

end
