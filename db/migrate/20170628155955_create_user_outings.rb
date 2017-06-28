class CreateUserOutings < ActiveRecord::Migration[5.0]
	def change
		create_table :user_outings do |t|
			t.references :user, foreign_key: true, null: false
			t.references :outing, foreign_key: true, null: false
			t.timestamps
		end
	end
end
