class CreateCreateTimeSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :time_slots do |t|
      t.references :service, null: false, foreign_key: true
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :capacity

      t.timestamps
    end
  end
end
