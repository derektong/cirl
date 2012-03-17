class ChildTopicsController < ApplicationController

  def index
    @child_topics = ChildTopic.find(:all, :order => 'description')
    @child_topic = ChildTopic.new
  end

  def create
    @child_topics = ChildTopic.find(:all, :order => 'description')
    @child_topic = ChildTopic.new(params[:child_topic])

    if @child_topic.save  
      redirect_to(child_topics_path) 
    else
      render 'index'
    end
  end

  def destroy
    ChildTopic.find(params[:id]).destroy
    flash[:success] = "Legal child_topic removed."
    respond_to do |format|
      format.html { redirect_to child_topics_path }
      format.js { render :js => "window.location = '" + child_topics_path + "'" }
    end
  end

  def update
    @child_topics = ChildTopic.all.sort_by {|a| a[:description].downcase}
    @edited_child_topic = ChildTopic.find(params[:id])
    @child_topic = ChildTopic.new
    if @edited_child_topic.update_attributes(:description => params[:update_value])
      redirect_to child_topics_path
    else
      render 'index'
    end
  end



end
