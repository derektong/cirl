module KeywordsHelper
  
  def get_links( process_topics, child_topics, refugee_topics )
    recommended = []
    required = []

    if !process_topics.nil?
      process_topics.each do |topic|
        topic.process_links.each do |link|
          recommended << link.keyword_id 
          if link.required
            required << link.keyword.id
          end
        end
      end
    end

    if !child_topics.nil?
      child_topics.each do |topic|
        topic.child_links.each do |link|
          recommended << link.keyword_id 
          if link.required
            required << link.keyword.id
          end
        end
      end
    end

    if !refugee_topics.nil?
      refugee_topics.each do |topic|
        topic.refugee_links.each do |link|
          recommended << link.keyword_id 
          if link.required
            required << link.keyword.id
          end
        end
      end
    end

    return [ recommended, required ]
  end

  def restore_default_keywords
    Keyword.destroy_all
    aliases = default_aliases
    default_keywords.each do |v|
      keyword = Keyword.new( description: v )
      if !keyword.save
        flash[:error] = "Error during restore process"
        return
      end
      if aliases[ v ] != nil
        aliases[ v ].each do |a|
          new_alias = keyword.aliases.new( description: a )
          if !new_alias.save
            flash[:error] = "Error adding alias: " + a
          end
        end
      end
    end
    flash[:success] = "Keywords successfully restored. \n"
  end

  private

  def default_keywords
    return [
      "Abandoned children",
      "Abortion",
      "Access to information",
      "Adequate standard of living",
      "Adoption",
      "Age as a change of circumstance",
      "Age as immutable characteristic",
      "Age of criminal responsibility",
      "Age-assessment",
      "Alienage",
      "Armed conflict, involvement in",
      "Arrest",
      "Benefit of the doubt",
      "Best interests",
      "Black children",
      "Bullying",
      "Burden or proof",
      "Cessation",
      "Change of circumstance",
      "Change of country conditions",
      "Child abduction",
      "Child labour",
      "Child pornography",
      "Child prostitution",
      "Child soldier",
      "Children deprived of family environment",
      "Children, risk because of being",
      "Choice of asylum country",
      "Civil war",
      "Complementary protection",
      "Constructive deportation",
      "Corporal punishment",
      "Corroboration",
      "Country of first asylum",
      "Country of origin information",
      "Country of origin reports",
      "Credibility",
      "Crimes against peace and security",
      "Cruel, inhuman or degrading treatment",
      "Culture, right to",
      "Customary international law",
      "Death penalty",
      "Definition of child",
      "Denial of custody",
      "Deportation of parent",
      "Derivative protection",
      "Designated representatives",
      "Detention",
      "Determining nationality",
      "Differential risk",
      "Disability, children with",
      "Discrimination",
      "Distinct risk",
      "Domestic child abuse",
      "Drug abuse",
      "Economic, social and cultural rights",
      "Education",
      "Ethnicity",
      "Evidential standards",
      "Exclusion",
      "Exclusion of parent",
      "Exploitation",
      "Failure of state protection",
      "Family environment, children deprived of",
      "Family life",
      "Family reunification",
      "Family, risk because of",
      "Female genital cutting",
      "Food",
      "Forced marriage",
      "Former gang members",
      "Forward-looking risk",
      "Fostering",
      "Freedom of association",
      "Freedom of conscience",
      "Freedom of expression",
      "Freedom of religion",
      "Freedom of thought",
      "Gang recruitment",
      "Gay and lesbian",
      "Gender",
      "Generalised risk",
      "Girl children",
      "Guardianship",
      "Habitual residence",
      "Harmful traditional practices",
      "Harm to family members",
      "Health",
      "Housing",
      "Humanitarian protection",
      "Identity",
      "Identity documents",
      "Illegal entry",
      "Imprisonment",
      "Imputed parental fear",
      "Imputed political opinion",
      "Incest",
      "Indigenous children",
      "Indirect persecution",
      "Indiscriminate harm",
      "Individual assessment",
      "Infant mortality",
      "Infanticide",
      "Juvenile justice",
      "Legal assistance",
      "Leisure, play and culture",
      "Linguistic analysis",
      "Medical treatment",
      "Medical illness, children with",
      "Membership of a particular social group",
      "Military recruitment",
      "Miscellaneous key words",
      "Modified standard",
      "Monitoring of treatment",
      "Multiple nationality",
      "Nationality",
      "Nexus",
      "Non-refoulement",
      "Non-separation",
      "Non-state agents of persecution",
      "Objective assessment of risk",
      "Orphanages",
      "Orphans",
      "Parental guidance",
      "Parental responsibility",
      "Participation",
      "Past persecution",
      "Persecution",
      "Political opinion",
      "Privacy",
      "Procedural concessions",
      "Prosecution v persecution",
      "Protection from violence",
      "Protection of rights",
      "Psychological harm",
      "Punishment and detention",
      "Race",
      "Rape",
      "Regionalised failure to protect",
      "Rehabilitation",
      "Religion",
      "Right of appeal",
      "Right to life",
      "Ritual sacrifice",
      "Safe third country",
      "Serious harm",
      "Serious non-political crimes",
      "Sexual abuse",
      "Sexual exploitation",
      "Shared duty of fact-finding",
      "Similarly situated persons",
      "Social security",
      "Standard of proof",
      "Starvation",
      "State of reference",
      "Statelessness",
      "Street children",
      "Subjective fear",
      "Sur place",
      "Survival and development",
      "Testimony",
      "Torture",
      "Tracing",
      "Trafficking",
      "Unaccompanied minors",
      "Unlawful departure",
      "Victims of crime",
      "Well-founded fear",
      "Widowed mothers, children of",
      "Witch children",
      "Young males"
    ]
  end

  def default_aliases
    return { 
      "Age-assessment" => [
        "Age determination" ],
      "Medical treatment" => [
        "Health services" ],
      "Detention" => [
        "Deprivation of liberty" ],
      "Choice of asylum country" => [
        "Protection elsewhere" ],
      "Domestic child abuse" => [
        "Parental abuse" ],
      "Civil war" => [
        "Internal conflict" ],
      "Gay and lesbian" => [
        "Sexual orientation" ],
      "Economic, social and cultural rights" => [
        "Socio-economic deprivation" ],
      "Regionalised failure to protect" => [
        "Internal relocation" ],
      "Nexus" => [
        "For reasons of", 
        "Causation" ],
      "Starvation" => [
        "Malnutrition" ],
      "Membership of a particular social group" => [
        "Particular social group" ],
      "Children, risk because of being" => [
        "Child as particular social group" ],
      "Family, risk because of" => [
        "Family as particular social group" ],
      "Black children" => [
        "Hei Haizi",
        "Illegitimate children",
        "One-child policy" ],
      "Discrimination" => [
        "Equality",
        "Non-discrimination" ],
      "Non-separation" => [
        "Family unity" ],
      "Child abduction" => [
        "Kidnapping" ],
      "Social security" => [
        "Social welfare" ],
    }
  end

end

