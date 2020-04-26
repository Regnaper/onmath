class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.string :name
      t.string :theme
      t.string :subtheme

      t.timestamps null: false
    end
  end
end
