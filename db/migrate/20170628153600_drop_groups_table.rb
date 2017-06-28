class DropGroupsTable < ActiveRecord::Migration[5.0]
	def up
		drop_table :group_users
		drop_table :groups
	end

	def down
		raise ActiveRecord::IrreversibleMigration
	end
end
