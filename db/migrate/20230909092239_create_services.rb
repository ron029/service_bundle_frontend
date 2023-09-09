class CreateServices < ActiveRecord::Migration[6.1]
  def change
    create_table :services do |t|
      t.references :user, foreign_key: true
      t.references :service_category, foreign_key: true
      t.string :name
      t.text :description
      t.text :image
      t.decimal :price, precision: 12, scale: 2

      t.timestamps
    end
  end
end
