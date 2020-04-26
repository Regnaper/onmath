class AddTestIdToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :test_id, :integer
    add_index :questions, [:test_id, :created_at]
    add_column :answers, :question_id, :integer
    add_index :answers, [:question_id, :created_at]
    add_index :tests, :name, unique: true
  end
end
