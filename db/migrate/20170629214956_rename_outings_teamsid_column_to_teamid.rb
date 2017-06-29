class RenameOutingsTeamsidColumnToTeamid < ActiveRecord::Migration[5.0]
  def change
  	rename_column :outings, :teams_id, :team_id
  end
end
