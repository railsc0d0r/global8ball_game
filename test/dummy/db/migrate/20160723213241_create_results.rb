class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.string :content
      t.references :game

      t.timestamps
    end
  end
end
