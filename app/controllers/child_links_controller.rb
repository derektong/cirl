class ChildLinksController < ApplicationController

  def create
    @linked_topic = ChildTopic.find(params[:child_topic][:id])
    @linked_keyword = Keyword.find(params[:keyword][:id])
    begin
      @linked_topic.link!(@linked_keyword, params[:required][:required])
    rescue ActiveRecord::RecordNotUnique
      flash[:error] = "Concept already linked to keyword"
    end
    redirect_to child_topics_path
  end

  def destroy
    @link = ChildLink.find(params[:id])
    @linked_topic = ChildTopic.find(@link.child_topic_id)
    @linked_keyword = Keyword.find(@link.keyword_id)
    @linked_topic.unlink!(@linked_keyword)
    redirect_to child_topics_path
  end

end

