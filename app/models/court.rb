class Court < ActiveRecord::Base
  attr_accessible :name, :jurisdiction_id

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => description_regex }

  belongs_to :jurisdiction
  has_many :cases
end
