class ChildTopic < ActiveRecord::Base
  attr_accessible :description, :keyword_ids

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :description, :presence => true,
                          :length => { :maximum => 100 },
                          :uniqueness => { :case_sensitive => false },
                          :format => { :with => description_regex }

  has_and_belongs_to_many :cases
  has_and_belongs_to_many :legal_briefs
  has_many :child_links, dependent: :destroy
  has_many :keywords, through: :child_links

  def linked?(keyword)
    child_links.find_by_keyword_id(keyword.id)
  end

  def link!(keyword, required)
    child_links.create!(keyword_id: keyword.id, required: required)
  end

  def unlink!(keyword)
    child_links.find_by_keyword_id(keyword.id).destroy
  end
end
