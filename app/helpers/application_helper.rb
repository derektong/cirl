module ApplicationHelper
  def title
    base_title = "CIRL"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def check_tab
    case_law_pages = [ "subjects", "issues", "jurisdictions" ]
    literature = [ "literature" ]
    if case_law_pages.include?(params[:controller])
      return "case_law_db"
    end
    if literature.include?(params[:controller])
      return "literature"
    end
    if params[:controller] == "pages" and params[:action] == "home"
      return "home"
    end
  end

end
