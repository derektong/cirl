class Jurisdiction < ActiveRecord::Base
  has_many :courts
  validates_presence_of :name
end
