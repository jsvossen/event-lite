class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :location
      t.text :description
      t.datetime :date, null: false
      
      t.timestamps null: false
    end
    add_reference :events, :creator, index: true, foreign_key: true
  end
end
