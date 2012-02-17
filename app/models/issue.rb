class Issue < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true,
                          :length => { :maximum => 50 },
                          :uniqueness => { :case_sensitive => false }

  has_and_belongs_to_many :cases
end
