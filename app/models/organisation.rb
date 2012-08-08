class Organisation < ActiveRecord::Base
  attr_accessible :name

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => description_regex }

  has_many :legal_briefs
end
