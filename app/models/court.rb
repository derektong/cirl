class Court < ActiveRecord::Base
  belongs_to :jurisdiction
  validates_presence_of :name
end
