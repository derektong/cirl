class RefugeeLink < ActiveRecord::Base
  attr_accessible :refugee_topic_id, :keyword_id, :required

  belongs_to :refugee_topic
  belongs_to :keyword
end
