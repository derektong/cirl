class CountryOrigin < ActiveRecord::Base
  attr_accessible :name 
  validates :name,  :presence => true,
                    :length => { :maximum => 50 }

  has_many :cases
  has_and_belongs_to_many :case_searches
end
