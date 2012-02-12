require 'spec_helper'

describe Jurisdiction do

  before(:each) do
    @attr = { :name => "Example Country" }
  end
  
  it "should create a new instance given valid attributes" do
    Jurisdiction.create!(@attr)
  end

  it "should require a name" do
    no_name_jurisdiction = Jurisdiction.new(@attr.merge(:name => ""))
    no_name_jurisdiction.should_not be_valid
  end

  it "should not have a name that is too long" do
    long_name = "a" * 51
    long_name_jurisdiction = Jurisdiction.new(@attr.merge(:name => long_name))
    long_name_jurisdiction.should_not be_valid
  end


end
