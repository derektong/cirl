class Jurisdiction < ActiveRecord::Base
  attr_accessible :name, :courts
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }

  has_many :courts, :dependent => :restrict, :order => "name"

  private

end
