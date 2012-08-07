module DocumentTypesHelper
  
  def restore_default_document_types
    DocumentType.destroy_all
    default_document_types.each do |k, v|
      publisher = Publisher.find_by_name( k )
      if publisher.nil?
        new_publisher = Publisher.new( name: k )
        if !new_publisher.save
          flash[:error] = "Error during restore process: \"" + k + "\""
          return
        end
        publisher = new_publisher
      end
      v.each do |c|
        document_type = DocumentType.new( publisher_id: publisher.id, name: c )
        if !document_type.save
          flash[:error] = "Error during restore process: \"" + c + "\""
          return
        end
      end
      flash[:success] = "DocumentTypes successfully restored"
    end
  end

  private

  def default_document_types
    return {
      "United National General Assembly" => [
        "Treaties",
        "Resolutions" ],
      "United Nations Secretary General" => [
        "Thematic reports" ],
      "United Nations High Commissioner for Refugees" => [
        "Executive Committee Conclusions",
        "Handbooks and manuals",
        "Thematic guidelines",
        "Speeches and statements",
        "Research and commentary",
        "Other material" ],
      "United Nations Committee on the Rights of the Child" => [
        "General Comments",
        "Discussion days" ],
      "United Nations Human Rights Committee" => [
        "General Comments",
        "Views" ],
      "Economic and Social Council" => [
        "Resolutions" ],
      "International Committee of the Red Cross" => [
        "Guidelines and manuals" ],
      "United Nations Committee on Economic, Social and Cultural Rights" => [
        "General Comments" ],
      "United Nations Human Rights Council" => [
        "Resolutions",
        "Thematic reports" ],
      "United Nations Office of the High Commissioner for Human Rights" => [
        "Thematic reports" ],
      "United Nations Office of the Special Representative of the Secretary-General for Children Affected by Armed Conflict " => [
        "Thematic reports" ],
      "Council of Europe" => [
        "Treaties",
        "Guidelines and manuals",
        "Research and commentary" ],
      "European Council on Refugees and Exiles" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "Separated Children in Europe Programme" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "Immigration Practitioners Law Association" => [
        "Research and commentary" ],
      "Coram Children's Legal Centre " => [
        "Research and commentary" ],
      "Save the Children" => [
        "Research and commentary",
        "Guidelines and manuals" ],
      "United Nations Children's Fund (UNICEF)" => [
        "Handbook and manuals",
        "Thematic guidelines",
        "Research and commentary",
        "Other material" ],
      "University of Michigan Law School" => [
        "Thematic guidelines" ],
      "Australia" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "New Zealand" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "United Kingdom" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "United States of America" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "Canada" => [
        "Guidelines and manuals",
        "Research and commentary" ],
      "European Union" => [
        "Treaties",
        "Guidelines and manuals",
        "Research and commentary" ],
      "Organisation of African Unity" => [
        "Treaties" ],
      "Inter-American Court of Human Rights" => [
        "Advisory Opinions" ],
      "Inter-American Commission of Human Rights" => [
        "Resolutions",
        "Thematic reports" ],
      "International Commission of Jurists" => [
        "Research and commentary" ]
    }
  end
end
