class Jurisdiction < ActiveRecord::Base
  attr_accessible :name, :courts
  validates :name,  :presence => true,
                    :length => { :maximum => 50 },
                    :uniqueness => { :case_sensitive => false }

  has_many :courts, :dependent => :restrict
  before_destroy :check_dependencies

  private

  def check_dependencies 
    begin
    rescue ArgumentError
    end
  end

end
