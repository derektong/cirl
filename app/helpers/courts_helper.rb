module CourtsHelper
  
  def restore_courts
    Court.destroy_all
    default_courts.each do |k, v|
      jurisdiction = Jurisdiction.find_by_name( k )
      if jurisdiction.nil?
        new_jurisdiction = Jurisdiction.new( name: k )
        if !new_jurisdiction.save
          flash[:error] = "Error during restore process"
          return
        end
        jurisdiction = new_jurisdiction
      end
      v.each do |c|
        court = Court.new( jurisdiction_id: jurisdiction.id, name: c )
        if !court.save
          flash[:error] = "Error during restore process"
          return
        end
      end
      flash[:success] = "Courts successfully restored"
    end
  end

  private

  def default_courts
    return {
      "Australia" => [
        "High Court",
        "Full Court of the Federal Court ",
        "Federal Court ",
        "Federal Magistrates Court",
        "Refugee Review Tribunal",
        "Administrative Appeals Tribunal" ],
      "New Zealand" => [
        "Supreme Court",
        "Court of Appeal",
        "High Court",
        "Refugee Status Appeals Authority",
        "Immigration Protection Tribunal" ],
      "United Kingdom" => [
        "Supreme Court",
        "House of Lords",
        "Court of Appeal",
        "High Court",
        "Inner House, Court of Session",
        "Outer House, Court of Session",
        "Upper Tribunal, Immigration and Asylum Chamber",
        "Asylum and Immigration Tribunal",
        "Immigration and Asylum Tribunal"],
      "United States of America" => [
        "Supreme Court",
        "Court of Appeals for the 1st Circuit",
        "Court of Appeals for the 2nd Circuit",
        "Court of Appeals for the 3rd Circuit",
        "Court of Appeals for the 4th Circuit",
        "Court of Appeals for the 5th Circuit",
        "Court of Appeals for the 6th Circuit",
        "Court of Appeals for the 7th Circuit",
        "Court of Appeals for the 8th Circuit",
        "Court of Appeals for the 9th Circuit",
        "Court of Appeals for the 10th Circuit",
        "Court of Appeals for the 11th Circuit",
        "District Court",
        "Board of Immigration Appeals",
        "Attorney General"],
      "Canada" => [
        "Supreme Court",
        "Federal Court of Appeal",
        "Federal Court",
        "Immigration and Refugee Board",
        "Ontario Court of Justice"],
      "European Union" => [
        "European Court of Justice",
        "European Court of Human Rights" ] 
    }

  end

end
