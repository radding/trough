class CreateTypePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :type_places do |t|
      t.references :place, foreign_key: true, null: false
      t.references :type, foreign_key: true, null: false
      t.timestamps
    end
  end
end
