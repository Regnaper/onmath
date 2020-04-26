class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer :test_id
      t.integer :user_id
      t.text :results, default: [].to_yaml

      t.timestamps null: false
    end
    add_index :results, :test_id
    add_index :results, :user_id
    add_index :results, [:test_id, :user_id], unique: true
  end
end