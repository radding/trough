class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.references :user, foreign_key: true, null: false
      t.references :place, foreign_key: true, null: false
      t.timestamps
    end
  end
end
