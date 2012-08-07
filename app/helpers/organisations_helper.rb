module OrganisationsHelper

  def restore_default_organisations
    Organisation.destroy_all
    default_organisations.each do |v|
      organisation = Organisation.new( name: v )
      if !organisation.save
        flash[:error] = "Error during restore process"
        return
      end
    end
    flash[:success] = "Organisations successfully restored. \n"
  end

  private

  def default_organisations
    return [
      "United Nations High Commissioner for Refugees",
      "Harvard Immigration and Refugee Clinic",
      "Strategic Litigation Fund"
    ]
  end
end
