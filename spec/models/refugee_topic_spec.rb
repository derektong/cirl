require 'spec_helper'

describe RefugeeTopic do

  before(:each) do
    @attr = { :description => "Example refugee_topic" }
  end
  
  it "should create a new instance given valid attributes" do
    RefugeeTopic.create!(@attr)
  end

  it "should require a description" do
    no_description_refugee_topic = RefugeeTopic.new(@attr.merge(:description => ""))
    no_description_refugee_topic.should_not be_valid
  end

  it "should not have a description that is too long" do
    long_description = "a" * 51
    long_description_refugee_topic = RefugeeTopic.new(@attr.merge(:description => long_description))
    long_description_refugee_topic.should_not be_valid
  end

  it "should reject duplicates" do
    upcased_description = @attr[:description].upcase
    RefugeeTopic.create!(@attr.merge(:description => upcased_description))
    refugee_topic_with_duplicate_description = RefugeeTopic.new(@attr)
    refugee_topic_with_duplicate_description.should_not be_valid
  end

  it "should reject non word characters" do
    nonword_refugee_topic = RefugeeTopic.new(@attr.merge(:description => "<br>"))
    nonword_refugee_topic.should_not be_valid
  end

end
