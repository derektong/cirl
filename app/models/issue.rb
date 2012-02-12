class Issue < ActiveRecord::Base
  attr_accessible :description

  validates :description, :presence => true,
                          :length => { :maximum => 50 }
end
