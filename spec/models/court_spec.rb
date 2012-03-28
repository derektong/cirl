require 'spec_helper'

describe Court do

  before do
    @court = Court.new(name: "Example Court")
  end

  subject { @court }
  
  it { should respond_to(:name) }
  
  it { should be_valid }

  describe "when name is not present" do
    before { @court.name = " " } 
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { long_name = "a" * 51
      @court.name = long_name }
    it { should_not be_valid }
  end


end
