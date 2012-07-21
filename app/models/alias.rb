class Alias < ActiveRecord::Base
  attr_accessible :description, :keyword_id

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :description, :presence => true,
                          :length => { :maximum => 100 },
                          :uniqueness => { :case_sensitive => false },
                          :format => { :with => description_regex }

  belongs_to :keyword
end
