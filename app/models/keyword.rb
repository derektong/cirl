class Keyword < ActiveRecord::Base
  attr_accessible :description

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :description, :presence => true,
                          :length => { :maximum => 100 },
                          :uniqueness => { :case_sensitive => false },
                          :format => { :with => description_regex }

  has_and_belongs_to_many :cases
  has_many :refugee_links, :dependent => :destroy
  has_many :refugee_topics, :through => :refugee_links
  has_many :process_links, :dependent => :destroy
  has_many :process_topics, :through => :process_links
  has_many :child_links, :dependent => :destroy
  has_many :child_topics, :through => :child_links
end
