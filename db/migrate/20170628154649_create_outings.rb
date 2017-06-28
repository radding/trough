class CreateOutings < ActiveRecord::Migration[5.0]
  def change
    create_table :outings do |t|
      t.string :name, null:false
      t.datetime :departure_time, null:false
      t.references :user, foreign_key: true, null: false
      t.references :teams, foreign_key: true, null: false
      t.references :place, foreign_key: true, null: false
      t.timestamps
    end
  end
end
