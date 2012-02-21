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

  it "should reject duplicates" do
    upcased_description = @attr[:description].upcase
    Issue.create!(@attr.merge(:description => upcased_description))
    issue_with_duplicate_description = Issue.new(@attr)
    issue_with_duplicate_description.should_not be_valid
  end

  it "should reject non word characters" do
    nonword_issue = Issue.new(@attr.merge(:description => "<br>"))
    nonword_issue.should_not be_valid
  end

end
