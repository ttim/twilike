class OpinionTranslate
  JOB_PRIORITY = 1

  def initialize(opinion)
    @opinion_id = opinion.id
  end

  def perform
    opinion = Opinion.find(@opinion_id)

    opinion.translated_text = GoogleTranslate.translate(opinion.text, "ru|en")
    
    opinion.save!
  end
end