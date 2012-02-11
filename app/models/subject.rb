class Subject < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true
end
