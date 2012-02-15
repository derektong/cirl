class Court < ActiveRecord::Base
  attr_accessible :name, :jurisdiction_id
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }

end
