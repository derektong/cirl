class Quote < ActiveRecord::Base
  attr_accessible :description
  validates :description,  :presence => true,
                           :length => { :maximum => 800 },
                           :uniqueness => { :case_sensitive => false }
end
