require 'spec_helper'

describe refugee_topic do

  before(:each) do
    @attr = { :description => "Example refugee_topic" }
  end
  
  it "should create a new instance given valid attributes" do
    refugee_topic.create!(@attr)
  end

  it "should require a description" do
    no_description_refugee_topic = refugee_topic.new(@attr.merge(:description => ""))
    no_description_refugee_topic.should_not be_valid
  end

  it "should not have a description that is too long" do
    long_description = "a" * 51
    long_description_refugee_topic = refugee_topic.new(@attr.merge(:description => long_description))
    long_description_refugee_topic.should_not be_valid
  end

  it "should reject duplicates" do
    upcased_description = @attr[:description].upcase
    refugee_topic.create!(@attr.merge(:description => upcased_description))
    refugee_topic_with_duplicate_description = refugee_topic.new(@attr)
    refugee_topic_with_duplicate_description.should_not be_valid
  end

  it "should reject non word characters" do
    nonword_refugee_topic = refugee_topic.new(@attr.merge(:description => "<br>"))
    nonword_refugee_topic.should_not be_valid
  end

end
