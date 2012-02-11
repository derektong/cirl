class Court < ActiveRecord::Base
  attr_accessible :name, :jurisdiction_id
  validates :name, :presence => true
end
