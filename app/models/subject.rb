class Subject < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true,
                          :length => { :maximum => 50 },
                          :uniqueness => { :case_sensitive => false }
end
