class QuestionThread < ApplicationRecord
  belongs_to :question
  scope :thread_id, -> (t=1){where("question_id = ?", t) }
end
