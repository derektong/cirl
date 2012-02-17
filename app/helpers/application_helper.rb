module ApplicationHelper
  def title(page_title)
    base_title = "CIRL"
    if page_title.nil?
      base_title
    else
      "#{base_title} | #{page_title}"
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

  def get_object_name( object_name )
    case object_name
    when "Subject"
      return "legal subject"
    when "Issue"
      return "legal issue"
    when "Jurisdiction"
      return "jurisdiction"
    when "Court"
      return "court"
    end
  end

  def get_countries
    return [ "Australia", "Brazil", "Canada" ]
  end

end
