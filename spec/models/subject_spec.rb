require 'spec_helper'

describe Subject do

  before(:each) do
    @attr = { :description => "Example Country" }
  end
  
  it "should create a new instance given valid attributes" do
    Subject.create!(@attr)
  end

  it "should require a description" do
    no_description_subject = Subject.new(@attr.merge(:description => ""))
    no_description_subject.should_not be_valid
  end
end
