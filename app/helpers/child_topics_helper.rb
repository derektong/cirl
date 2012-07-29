module ChildTopicsHelper
  
  def restore_child_topics
    ChildTopic.destroy_all
    default_child_topics.each do |k, v|
      new_child_topic = ChildTopic.new( description: k )
      if !new_child_topic.save
        flash[:error] = "Error during restore child " + k
        return 
      end
      v.each do |i|
        i.each do |k2, v2| 
          keyword = Keyword.find_by_description( k2 )
          if keyword.nil?
            flash[:error] = "Error during restore child " + k2
            return
          end
          begin
            new_child_topic.link!( keyword, v2 )
          rescue
            flash[:error] = "Error during restore child " + k2
            return
          end
        end
      end
    end
    flash[:success] = "Child concepts successfully restored"
  end

  private

  def default_child_topics
    return { 
      "Definition of child (art. 1)" => [
        { "Definition of child" => true },
        { "Age as immutable characteristic" => false } ],
      "Equality and non-discrimination (art. 2, 22)" => [
        { "Discrimination" => true } ],
      "Best interests (art. 3)" => [
        { "Best interests" => true },
        { "Humanitarian protection" => false },
        { "Complementary protection" => false },
        { "Unaccompanied minors" => false },
        { "Participation" => false },
        { "Non-separation" => false } ],
      "Protection of rights (art. 4)" => [
        { "Protection of rights" => true } ],
      "Parental guidance (art. 5)" => [
        { "Parental guidance" => true },
        { "Domestic child abuse" => false },
        { "Participation" => false },
        { "Non-separation" => false } ],
      "Right to life, survival and development (art. 6)" => [
        { "Survival and development" => true },
        { "Right to life" => true },
        { "Non-refoulement" => false },
        { "Complementary protection" => false },
        { "Protection from violence" => false },
        { "Health" => false },
        { "Education" => false },
        { "Adequate standard of living" => false },
        { "Infanticide" => false },
        { "Abortion" => false },
        { "Death penalty" => false },
        { "Infant mortality" => false },
        { "Domestic child abuse" => false } ],
      "Identity (arts. 7-8)" => [
        { "Identity" => true },
        { "Black children" => false } ],
      "Non-separation (art. 9)" => [
        { "Non-separation" => true },
        { "Deportation of parent" => false },
        { "Participation" => false },
        { "Privacy" => false },
        { "Distinct risk" => false },
        { "Denial of custody" => false },
        { "Indirect persecution" => false },
        { "Derivative protection" => false },
        { "Constructive deportation" => false } ],
      "Family reunification (art. 10)" => [
        { "Family reunification" => true },
        { "Unaccompanied minors" => false } ],
      "Child abduction (art. 11)" => [
        { "Child abduction" => true },
        { "Non-separation" => false },
        { "Participation" => false },
        { "Domestic child abuse" => false },
        { "Parental guidance" => false },
        { "Survival and development" => false },
        { "Protection from violence" => false } ],
      "Participation (art. 12)" => [
        { "Participation" => true },
        { "Individual assessment" => false },
        { "Distinct risk" => false },
        { "Indirect persecution" => false },
        { "Derivative protection" => false },
        { "Constructive deportation" => false } ],
      "Freedom of expression (art. 13)" => [
        { "Freedom of expression" => true },
        { "Political opinion" => false } ],
      "Freedom of thought, conscience or religion (art. 14)" => [
        { "Freedom of thought" => true },
        { "Political opinion" => false },
        { "Religion" => false } ],
      "Freedom of association (art. 15)" => [
        { "Freedom of association" => true },
        { "Political opinion" => false } ],
      "Privacy and family life (art. 16)" => [
        { "Privacy" => true },
        { "Family reunification" => false } ],
      "Access to information (art. 17)" => [
        { "Access to information" => true } ],
      "Parental responsibility (art. 18)" => [
        { "Parental responsibility" => true } ],
      "Protection from violence (art. 19)" => [
        { "Protection from violence" => true },
        { "Domestic child abuse" => false },
        { "Survival and development" => false } ],
      "Children deprived of family environment (art. 20)" => [
        { "Family environment, children deprived of" => true },
        { "Guardianship" => false } ],
      "Adoption (art. 21)" => [
        { "Adoption" => true } ],
      "Refugee children (art. 22)" => [
        { "Discrimination" => false },
        { "Non-separation" => false },
        { "Family reunification" => false },
        { "Unaccompanied minors" => false },
        { "Guardianship" => false } ],
      "Children with disabilities (art. 23)" => [
        { "Disability, children with" => true },
        { "Medical illness, children with" => false },
        { "Health" => false },
        { "Medical care" => false } ],
      "Health (art. 24)" => [
        { "Health" => true },
        { "Medical illness, children with" => false },
        { "Medical care" => false },
        { "Survival and development" => false },
        { "Right to life" => false },
        { "Economic, social and cultural rights" => false } ],
      "Harmful traditional practices (art. 24(3))" => [
        { "Health" => true },
        { "Harmful traditional practices" => true },
        { "Female genital cutting" => false } ],
      "Monitoring of treatment (art. 25)" => [
        { "Monitoring of treatment" => true },
        { "Health" => true },
        { "Medical illness, children with" => false },
        { "Medical care" => false } ],
      "Social security (art. 26)" => [
        { "Social security" => true } ],
      "Adequate standard of living (art. 27)" => [
        { "Adequate standard of living" => true },
        { "Survival and development" => false } ],
      "Education (arts. 28-29)" => [
        { "Education" => true },
        { "Economic, social and cultural rights" => false },
        { "Survival and development" => false } ],
      "Indigenous children (art. 30)" => [
        { "Indigenous children" => true },
        { "Discrimination" => false } ],
      "Leisure, play and culture (art. 31)" => [
        { "Leisure, play and culture" => true },
        { "Culture, right to" => false } ],
      "Child labour (art. 32)" => [
        { "Child labour" => true } ],
      "Drug abuse (art. 33)" => [
        { "Drug abuse" => true } ],
      "Protection against exploitation (arts. 34 and 36, Optional Protocol)"=> [
        { "Sexual exploitation" => true },
        { "Incest" => false },
        { "Sexual abuse" => false } ],
      "Abduction, sale and trafficking (art. 35, Optional Protocol)" => [
        { "Child abduction" => false },
        { "Trafficking" => false },
        { "Child prostitution" => false },
        { "Child pornography" => false },
        { "Sexual exploitation" => false } ],
      "Punishment and detention (art. 37)" => [
        { "Punishment and detention" => true },
        { "Torture " => false },
        { "Cruel, inhuman or degrading treatment " => false },
        { "Detention" => false },
        { "Complementary protection" => false },
        { "Non-refoulement" => false },
        { "Imprisonment" => false },
        { "Arrest" => false } ],
      "Involvement in armed conflict (art. 38, Optional Protocol)" => [
        { "Armed conflict, involvement in" => true },
        { "Military recruitment" => false },
        { "Civil war" => false },
        { "Child soldier" => false } ],
      "Rehabilitation (art. 39)" => [
        { "Rehabilitation" => true },
        { "Psychological harm" => false },
        { "Medical care" => false },
        { "Health" => false } ],
      "Juvenile justice (art. 40)" => [
        { "Juvenile justice" => true },
        { "Participation" => false },
        { "Exclusion" => false },
        { "Prosecution v persecution" => false },
        { "Crimes against peace and security" => false },
        { "Serious non-political crimes" => false },
        { "Imprisonment" => false },
        { "Arrest" => false },
        { "Age of criminal responsibility" => false } ],
    }
  end
end
