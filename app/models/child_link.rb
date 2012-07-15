class ChildLink < ActiveRecord::Base
  attr_accessible :child_topic_id, :keyword_id, :required

  belongs_to :child_topic
  belongs_to :keyword
end
