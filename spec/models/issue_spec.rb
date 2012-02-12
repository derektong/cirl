require 'spec_helper'

describe Issue do

  before(:each) do
    @attr = { :description => "Example Issue" }
  end
  
  it "should create a new instance given valid attributes" do
    Issue.create!(@attr)
  end

  it "should require a description" do
    no_description_issue = Issue.new(@attr.merge(:description => ""))
    no_description_issue.should_not be_valid
  end

  it "should not have a description that is too long" do
    long_description = "a" * 51
    long_description_issue = Issue.new(@attr.merge(:description => long_description))
    long_description_issue.should_not be_valid
  end


end
