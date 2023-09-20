class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.integer :status

      t.timestamps
    end
  end
end
