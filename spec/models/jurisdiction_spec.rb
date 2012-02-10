require 'spec_helper'

describe Jurisdiction do

  before(:each) do
    @attr = { :name => "Example Country" }
  end
  
  it "should create a new instance given valid attributes" do
    Jurisdiction.create!(@attr)
  end

  it "should require a name"
end
