class CreateZipcodes < ActiveRecord::Migration[4.2]
  def change
    create_table :zipcodes do |t|
      t.string :code

      t.timestamps null: false
    end
  end
end
