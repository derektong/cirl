class ProcessLinksController < ApplicationController

  def create
    @linked_topic = ProcessTopic.find(params[:process_topic][:id])
    @linked_keyword = Keyword.find(params[:keyword][:id])
    begin
      @linked_topic.link!(@linked_keyword, params[:required][:required])
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "Concept already linked to keyword"
    end
    redirect_to process_topics_path
  end

  def destroy
    @link = ProcessLink.find(params[:id])
    @linked_topic = ProcessTopic.find(@link.process_topic_id)
    @linked_keyword = Keyword.find(@link.keyword_id)
    @linked_topic.unlink!(@linked_keyword)
    redirect_to process_topics_path
  end

end

