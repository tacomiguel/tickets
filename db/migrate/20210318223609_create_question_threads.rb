class CreateQuestionThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :question_threads do |t|
      t.string :name
      t.string :valor
      t.references :question
      t.timestamps
    end
  end
end
