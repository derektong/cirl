class DocumentType < ActiveRecord::Base
  attr_accessible :name, :publisher_id

  description_regex = /\A[\w\-\s\(\)\.,]+\Z/

  validates :name,  :presence => true,
                    :length => { :maximum => 200 },
                    :format => { :with => description_regex }

  belongs_to :publisher
  #has_many :legal_resources
end
