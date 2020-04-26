class AddParametersToResult < ActiveRecord::Migration[5.2]
  def change
    add_column :results, :attempt_count, :integer, default: 3
    add_column :results, :pass_time, :integer, default: 20
  end
end
