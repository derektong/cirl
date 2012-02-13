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

  it "should not have a description that is too long" do
    long_description = "a" * 51
    long_description_subject = Subject.new(@attr.merge(:description => long_description))
    long_description_subject.should_not be_valid
  end

  it "should reject duplicates" do
    upcased_description = @attr[:description].upcase
    Subject.create!(@attr.merge(:description => upcased_description))
    subject_with_duplicate_description = Subject.new(@attr)
    subject_with_duplicate_description.should_not be_valid
  end

end
