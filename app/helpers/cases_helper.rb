module CasesHelper
  
  def get_links( process_topics, child_topics, refugee_topics )
    recommended = []
    required = []

    process_topics.each do |topic|
      topic.process_links.each do |link|
        recommended << link.keyword_id 
        if link.required
          required << link.keyword.id
        end
      end
    end

    child_topics.each do |topic|
      topic.child_links.each do |link|
        recommended << link.keyword_id 
        if link.required
          required << link.keyword.id
        end
      end
    end

    refugee_topics.each do |topic|
      topic.refugee_links.each do |link|
        recommended << link.keyword_id 
        if link.required
          required << link.keyword.id
        end
      end
    end
    return [ recommended, required ]
  end
end
