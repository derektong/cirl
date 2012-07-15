module KeywordsHelper
  
  def restore_keywords
    Keyword.destroy_all
    default_keywords.each do |v|
      keyword = Keyword.new( description: v )
      if !keyword.save
        flash[:error] = "Error during restore process"
        return
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
      "Age determination",
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
      "Causation",
      "Cessation",
      "Change of circumstance",
      "Change of country conditions",
      "Child abduction ",
      "Child as particular social group",
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
      "Definition of child",
      "Deportation of parent",
      "Deprivation of liberty",
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
      "Equality",
      "Ethnicity",
      "Evidential standards",
      "Exclusion",
      "Exclusion of parent",
      "Failure of state protection",
      "Family as particular social group",
      "Family environment, children deprived of",
      "Family life",
      "Family reunification",
      "Family unity",
      "Family, risk because of",
      "Female genital cutting",
      "For reasons of",
      "Forced marriage",
      "Former gang members",
      "Forward-looking risk",
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
      "Harmful traditional practices",
      "Health",
      "Hei Haizi",
      "Humanitarian protection",
      "Identity",
      "Identity documents",
      "Illegal entry",
      "Illegitimate children",
      "Imprisonment",
      "Imputed parental fear",
      "Imputed political opinion",
      "Incest",
      "Indigenous children",
      "Indirect persecution",
      "Indiscriminate harm",
      "Individual assessment",
      "Infanticide",
      "Internal relocation",
      "Juvenile justice",
      "Kidnapping",
      "Legal assistance",
      "Leisure, play and culture",
      "Linguistic analysis",
      "Medical care",
      "Medical illness, children with ",
      "Membership of a particular social group",
      "Military recruitment",
      "Miscellaneous key words",
      "Modified standard",
      "Monitoring of treatment",
      "Multiple nationality",
      "Nationality",
      "Nexus",
      "Non-discrimination",
      "Non-refoulement",
      "Non-separation",
      "Non-state agents ",
      "Objective assessment of risk",
      "One-child policy",
      "Orphans",
      "Parental abuse",
      "Parental guidance",
      "Parental responsibility",
      "Participation",
      "Particular social group",
      "Past persecution",
      "Persecution",
      "Political opinion",
      "Potential key words ",
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
      "Safe third country",
      "Serious harm",
      "Serious non-political crimes",
      "Sexual abuse",
      "Sexual exploitation",
      "Shared duty of fact-finding",
      "Similarly situated persons",
      "Social security",
      "Socio-economic deprivation",
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
end

