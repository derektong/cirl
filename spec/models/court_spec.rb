require 'spec_helper'

describe Court do

  before(:each) do
    @attr = { :name => "Example Court", :jurisdiction_id => "0" }
  end
  
  it "should create a new instance given valid attributes" do
    Court.create!(@attr)
  end

  it "should require a name" do
    no_name_court = Court.new(@attr.merge(:name => ""))
    no_name_court.should_not be_valid
  end

  it "should not have a name that is too long" do
    long_name = "a" * 51
    long_name_court = Court.new(@attr.merge(:name => long_name))
    long_name_court.should_not be_valid
  end



end
