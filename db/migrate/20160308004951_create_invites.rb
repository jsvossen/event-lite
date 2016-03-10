class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.references :attendee, index: true, foreign_key: true, null: false
      t.references :attended_event, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
    add_index :invites, [:attendee_id, :attended_event_id], :unique => true
  end
end
