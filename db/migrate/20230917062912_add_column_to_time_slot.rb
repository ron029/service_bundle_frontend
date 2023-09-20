class AddColumnToTimeSlot < ActiveRecord::Migration[6.1]
  def change
    add_column :time_slots, :end_date, :date
    rename_column :time_slots, :date, :start_date
  end
end
