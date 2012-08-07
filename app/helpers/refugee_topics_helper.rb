module RefugeeTopicsHelper
  
  def restore_default_refugee_topics
    RefugeeTopic.destroy_all
    default_refugee_topics.each do |k, v|
      new_refugee_topic = RefugeeTopic.new( description: k )
      if !new_refugee_topic.save
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
            new_refugee_topic.link!( keyword, v2 )
          rescue
            flash[:error] = "Error during restore process " + k2
            return
          end
        end
      end
    end
    flash[:success] += "Refugee concepts successfully restored. \n"
  end

  private

  def default_refugee_topics
    return {
      "Alienage" => [
        { "Alienage" => true },
        { "Choice of asylum country" => false },
        { "Illegal entry" => false },
        { "Habitual residence" => false },
        { "Country of first asylum" => false },
        { "Safe third country" => false },
        { "State of reference" => false },
        { "Statelessness" => false },
        { "Sur place" => false },
        { "Multiple nationality" => false },
        { "Determining nationality" => false },
        { "Identity documents" => false },
        { "Non-refoulement" => false } ],
      "Well-founded fear" => [
        { "Well-founded fear" => true },
        { "Forward-looking risk" => false },
        { "Subjective fear" => false },
        { "Objective assessment of risk" => false },
        { "Similarly situated persons" => false },
        { "Generalised risk" => false },
        { "Indiscriminate harm" => false },
        { "Distinct risk" => false },
        { "Differential risk" => false },
        { "Imputed parental fear" => false },
        { "Country of origin reports" => false },
        { "Change of country conditions" => false } ],
      "Serious harm" => [ 
        { "Persecution" => true },
        { "Serious harm" => true },
        { "Modified standard" => false },
        { "Domestic child abuse" => false },
        { "Detention" => false },
        { "Cruel, inhuman or degrading treatment" => false },
        { "Indirect persecution" => false },
        { "Harm to family members" => false },
        { "Starvation" => false },
        { "Female genital cutting" => false },
        { "Incest" => false },
        { "Forced marriage" => false },
        { "Sexual abuse" => false },
        { "Torture" => false },
        { "Child prostitution" => false },
        { "Child pornography" => false },
        { "Sexual exploitation" => false },
        { "Ritual sacrifice" => false },
        { "Trafficking" => false },
        { "Infanticide" => false },
        { "Abortion" => false },
        { "Child labour" => false },
        { "Military recruitment" => false },
        { "Gang recruitment" => false },
        { "Economic, social and cultural rights" => false },
        { "Health" => false },
        { "Medical treatment" => false },
        { "Housing" => false },
        { "Survival and development" => false },
        { "Education" => false },
        { "Non-separation" => false },
        { "Psychological harm" => false },
        { "Bullying" => false },
        { "Corporal punishment" => false },
        { "Civil war" => false },
        { "Discrimination" => false },
        { "Imprisonment" => false },
        { "Arrest" => false },
        { "Prosecution v persecution" => false },
        { "Death penalty" => false },
        { "Infant mortality" => false },
        { "Past persecution" => false } ],
      "Failure of state protection" => [
        { "Failure of state protection" => true },
        { "Non-state agents of persecution" => false },
        { "Domestic child abuse" => false },
        { "Regionalised failure to protect" => false } ],
      "Nexus" => [
        { "Nexus" => true },
        { "Indiscriminate harm" => false },
        { "Victims of crime" => false },
        { "Civil war" => false },
        { "Prosecution v persecution" => false },
        { "Unlawful departure" => false },
        { "Generalised risk" => false } ],
      "Convention ground - Race" => [
        { "Race" => true },
        { "Ethnicity" => false } ],
      "Convention ground - Nationality" => [
        { "Nationality" => true } ],
      "Convention ground - Political opinion" => [
        { "Political opinion" => true },
        { "Imputed political opinion" => false },
        { "Freedom of expression" => false },
        { "Freedom of association" => false },
        { "Freedom of thought" => false } ],
      "Convention ground - Religion" => [
        { "Religion" => true },
        { "Freedom of thought" => false } ],
      "Convention ground - Membership of a particular social group" => [
        { "Membership of a particular social group" => true },
        { "Children, risk because of being" => false },
        { "Family, risk because of" => false },
        { "Age as immutable characteristic" => false },
        { "Discrimination" => false },
        { "Unaccompanied minors" => false },
        { "Orphans" => false },
        { "Girl children" => false },
        { "Gender" => false },
        { "Young males" => false },
        { "Child soldier" => false },
        { "Street children" => false },
        { "Forced marriage" => false },
        { "Female genital cutting" => false },
        { "Witch children" => false },
        { "Gay and lesbian" => false },
        { "Black children" => false },
        { "Disability, children with" => false },
        { "Medical illness, children with" => false },
        { "Widowed mothers, children of" => false },
        { "Domestic child abuse" => false },
        { "Military recruitment" => false },
        { "Gang recruitment" => false },
        { "Former gang members" => false },
        { "Abandoned children" => false },
        { "Trafficking" => false } ],
      "Cessation" => [
        { "Cessation" => true },
        { "Age as a change of circumstance" => false },
        { "Change of circumstance" => false },
        { "Age as immutable characteristic" => false } ],
      "Exclusion" => [
        { "Exclusion" => true },
        { "Crimes against peace and security" => false },
        { "Serious non-political crimes" => false },
        { "Child soldier" => false },
        { "Exclusion of parent" => false },
        { "Age of criminal responsibility" => false } ]
    }
  end
end
