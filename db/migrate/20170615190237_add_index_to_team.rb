class AddIndexToTeam < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :name
    add_column :teams, :name, :string
    add_index :teams, :name, unique: true
  end
end
