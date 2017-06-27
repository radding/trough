class AddTeamsToGroups < ActiveRecord::Migration[5.0]
  def change
  	add_reference :groups, :teams, foreign_key: true, null: false
  end
end
