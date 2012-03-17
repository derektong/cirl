require 'spec_helper'

describe child_topic do

  before(:each) do
    @attr = { :description => "Example Country" }
  end
  
  it "should create a new instance given valid attributes" do
    child_topic.create!(@attr)
  end

  it "should require a description" do
    no_description_child_topic = child_topic.new(@attr.merge(:description => ""))
    no_description_child_topic.should_not be_valid
  end

  it "should not have a description that is too long" do
    long_description = "a" * 51
    long_description_child_topic = child_topic.new(@attr.merge(:description => long_description))
    long_description_child_topic.should_not be_valid
  end

  it "should reject duplicates" do
    upcased_description = @attr[:description].upcase
    child_topic.create!(@attr.merge(:description => upcased_description))
    child_topic_with_duplicate_description = child_topic.new(@attr)
    child_topic_with_duplicate_description.should_not be_valid
  end

end
