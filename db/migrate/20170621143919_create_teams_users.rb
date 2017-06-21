class CreateTeamsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :teams_users do |t|
      t.references :teams, foreign_key: true, null: false
      t.references :users, foreign_key: true, null: false
      t.timestamps
    end
  end
end
