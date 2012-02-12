require 'spec_helper'

describe SubjectsController do
  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end

    it "should have the right title" do
      get 'index'
      response.should have_selector("title", :content => "Manage Subjects")
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit'
      response.should be_success
    end
  end

  
  describe "POST 'create'" do

    describe "failure" do

      before (:each) do
        @attr = { :description => "" }
      end

      it "should not create a subject" do
        lambda do
          post :create, :subject => @attr
        end.should_not change(Subject, :count)
      end

      it "should have the right title" do
        post :create, :subject => @attr
        response.should have_selector("title", :content => "Manage Subjects")
      end

      it "should render the 'index' page" do
        post :create, :subject => @attr
        response.should render_template("index")
      end
    end
  end

end
