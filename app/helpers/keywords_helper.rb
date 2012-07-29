module KeywordsHelper

  def restore_keywords
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
    flash[:success] = "Keywords successfully restored"
  end

  private

  def default_keywords
    return [
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
      "Country of origin information",
      "Country of origin reports",
      "Credibility",
      "Crimes against peace and security",
      "Cruel, inhuman or degrading treatment ",
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
      "Failure of state protection",
      "Family environment, children deprived of",
      "Family reunification",
      "Family, risk because of",
      "Female genital cutting",
      "Forced marriage",
      "Former gang members",
      "Forward-looking risk",
      "Freedom of association",
      "Freedom of expression",
      "Freedom of thought",
      "Gang recruitment",
      "Gay and lesbian",
      "Gender",
      "Generalised risk",
      "Girl children",
      "Guardianship",
      "Harmful traditional practices",
      "Health",
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
      "Medical care",
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
      "Non-state agents",
      "Objective assessment of risk",
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
      "Regionalised failure to protect",
      "Rehabilitation",
      "Religion",
      "Right to life",
      "Ritual sacrifice",
      "Serious harm",
      "Serious non-political crimes",
      "Sexual abuse",
      "Sexual exploitation",
      "Shared duty of fact-finding",
      "Similarly situated persons",
      "Social security",
      "Standard of proof",
      "State of reference",
      "Statelessness",
      "Street children",
      "Subjective fear",
      "Sur place",
      "Survival and development",
      "Testimony",
      "Torture ",
      "Trafficking",
      "Unaccompanied minors",
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
      "Detention" => [
        "Deprivation of liberty" ],
      "Choice of asylum country" => [
        "Safe third country" ],
      "Domestic child abuse" => [
        "Parental abuse" ],
      "Economic, social and cultural rights" => [
        "Socio-economic deprivation" ],
      "Regionalised failure to protect" => [
        "Internal relocation" ],
      "Nexus" => [
        "For reasons of", 
        "Causation" ],
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
      "Freedom of thought" => [
        "Freedom of conscience",
        "Freedom of religion" ],
      "Privacy" => [
        "Family life" ],
      "Sexual exploitation" => [
        "Exploitation" ]
    }
  end

end

