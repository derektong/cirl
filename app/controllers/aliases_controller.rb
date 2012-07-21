class AliasesController < ApplicationController


  def create
  end

  
  def create 
    @keyword = Keyword.find(params[:id])
    @alias = @keyword.aliases.new( description: params[:description] )
    if @alias.save
      flash[:success] = "Alias: \"" + @alias.description + "\" added"
    else
      flash[:error] = "Error adding alias: \"" + params[:description] + "\""
    end
    redirect_to keywords_path
  end


  def destroy
    keyword = Keyword.find(params[:keyword_id])
    @alias = keyword.aliases.find(params[:id])
    @alias.destroy
    flash[:success] = "Alias: \"" + @alias.description + "\" removed"
    redirect_to keywords_path
  end



end
