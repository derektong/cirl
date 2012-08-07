module QuotesHelper

  def restore_default_quotes
    Quote.destroy_all
    default_quotes.each do |v|
      quote = Quote.new( description: v )
      if !quote.save
        flash[:error] = "Error during restore process"
        return
      end
    end
    flash[:success] = "Quotes successfully restored. \n"
  end

  private

  def default_quotes
    return [
      "\"In all actions concerning children, whether undertaken by public or private social welfare institutions, courts of law, administrative authorities or legislative bodies, the best interests of the child shall be a primary consideration.\" Convention on the Rights of the Child, Article 3.",
      "\"State Parties shall assure to the child who is capable of forming his or her own views the right to express those views freely in all matters affecting the child, the views of the child being given due weight in accordance with the age and maturity of the child.\" Convention on the Rights of the Child, Article 12.",
      "\"[T]he refugee definition... must be interpreted in an age and gender-sensitive manner, taking into account the particular motives for, and forms and manifestations of, persecution experienced by children. Persecution of kin; under-age recruitment; trafficking of children for prostitution; and sexual exploitation or subjection to female genital mutilation, are some of the child-specific forms and manifestations of persecution which may justify the granting of refugee status if such acts are related to one of the 1951 Refugee Convention grounds.\" UN Committee on the Rights of the Child, General Comment No. 6, [74].",
      "\"Was his school experience persecutory? From the lordly perch of an adult, one could say it was not. The reason for such a view is, of course, that the Convention refugee definition and its evolving law is mostly about adults. 'Persecution' - the single most important concept in refugee law takes adult situations into account... The regime of rights that adults have developed is in response to adult needs, the unjust denial of which is tantamount to persecution. I believe, however, that the term 'persecution' needs to be made relevant to the word of the child as well.\" BNY (Re), Nos TA1-03656, TA1-03657, TA1-0368 [2002] RPDD No. 223, 19 December 2002, at [7]-[9]."
    ]
  end
end
