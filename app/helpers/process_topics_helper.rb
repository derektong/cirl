module ProcessTopicsHelper
  
  def restore_process_topics
    ProcessTopic.destroy_all
    default_process_topics.each do |k, v|
      new_process_topic = ProcessTopic.new( description: k )
      if !new_process_topic.save
        flash[:error] = "Error during restore process"
        return 
      end
      v.each do |i|
        i.each do |k2, v2| 
          keyword = Keyword.find_by_description( k2 )
          if keyword.nil?
            flash[:error] = "Error during restore process " + k2
            return
          end
          begin
            new_process_topic.link!( keyword, v2 )
          rescue
            flash[:error] = "Error during restore process " + k2
            return
          end
        end
      end
    end
    flash[:success] = "Process concepts successfully restored"
  end

  private

  def default_process_topics
    return { 
      "Individual assessment" => [
        { "Individual assessment" => true },
        { "Participation" => true },
        { "Distinct risk" => false },
        { "Indirect persecution" => false },
        { "Derivative protection" => false },
        { "Constructive deportation" => false } ],
      "Procedural concessions" => [
        { "Procedural concessions" => true },
        { "Testimony" => false },
        { "Unaccompanied minors" => false } ],
      "Evidential standards" => [
        { "Evidential standards" => true },
        { "Burden or proof" => false },
        { "Standard of proof" => false },
        { "Benefit of the doubt" => false },
        { "Shared duty of fact-finding" => false },
        { "Country of origin information" => false } ],
      "Credibility" => [
        { "Credibility" => true },
        { "Evidential standards" => false },
        { "Benefit of the doubt" => false },
        { "Age-assessment" => false },
        { "Age determination" => false },
        { "Linguistic analysis" => false },
        { "Testimony" => false },
        { "Corroboration" => false } ],
      "Legal assistance" => [
        { "Legal assistance" => true },
        { "Designated representatives" => false },
        { "Best interests" => false },
        { "Unaccompanied minors" => false } ],
      "Guardianship" => [
        { "Guardianship" => true },
        { "Designated representatives" => false },
        { "Best interests" => false },
        { "Children deprived of family environment" => false },
        { "Unaccompanied minors" => false } ],
      "Age-assessment" => [
        { "Age-assessment" => true },
        { "Age determination" => true },
        { "Credibility" => false } ],
      "Detention" => [
        { "Detention" => true },
        { "Deprivation of liberty" => true } ]
    }
  end
end
