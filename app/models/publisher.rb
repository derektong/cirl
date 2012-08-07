class Publisher < ActiveRecord::Base
  attr_accessible :name, :document_types
  validates :name,  :presence => true,
                    :length => { :maximum => 200 },
                    :uniqueness => { :case_sensitive => false }

  has_many :document_types, :dependent => :restrict, :order => "name"

  private

end
