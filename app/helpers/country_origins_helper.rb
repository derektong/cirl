module CountryOriginsHelper
  include ApplicationHelper

  def restore_country_origins
    CountryOrigin.destroy_all
    get_countries.each do |v|
      country_origin = CountryOrigin.new( name: v )
      if !country_origin.save
        flash[:error] = "Error during restore process"
        return
      end
    end
    flash[:success] = "CountryOrigins successfully restored"
  end

end

