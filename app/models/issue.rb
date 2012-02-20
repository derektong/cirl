class Issue < ActiveRecord::Base
  attr_accessible :description

  description_regex = /\A\w+\Z/

  validates :description, :presence => true,
                          :length => { :maximum => 50 },
                          :uniqueness => { :case_sensitive => false },
                          :format => { :with => description_regex }

  has_and_belongs_to_many :cases
end
