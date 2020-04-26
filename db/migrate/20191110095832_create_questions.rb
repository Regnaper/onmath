class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :question
      t.integer :right_answer

      t.timestamps null: false
    end
  end
end
