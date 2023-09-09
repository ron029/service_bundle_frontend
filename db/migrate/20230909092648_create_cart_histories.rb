class CreateCartHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_histories do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :payment_option, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :contact_number
      t.string :email

      t.timestamps
    end
  end
end
