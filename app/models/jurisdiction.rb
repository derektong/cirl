class Jurisdiction < ActiveRecord::Base
  attr_accessible :name
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }
  has_many :courts
end
