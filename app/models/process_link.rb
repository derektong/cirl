class ProcessLink < ActiveRecord::Base
  attr_accessible :process_topic_id, :keyword_id, :required

  belongs_to :process_topic
  belongs_to :keyword
end
