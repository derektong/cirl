class Keyword < ActiveRecord::Base
  attr_accessible :description

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :description, :presence => true,
                          :length => { :maximum => 100 },
                          :uniqueness => { :case_sensitive => false },
                          :format => { :with => description_regex }

  has_and_belongs_to_many :cases
  has_and_belongs_to_many :legal_briefs
  has_many :aliases, :dependent => :destroy
  has_many :refugee_links, :dependent => :destroy
  has_many :refugee_topics, :through => :refugee_links
  has_many :process_links, :dependent => :destroy
  has_many :process_topics, :through => :process_links
  has_many :child_links, :dependent => :destroy
  has_many :child_topics, :through => :child_links

  def keywords_with_aliases
    keywords_with_aliases = []
    keywords_with_aliases << [self.description, self.id]
    self.aliases.each do |a|
      keywords_with_aliases << [a.description, self.id]
    end
    return keywords_with_aliases
  end
end
