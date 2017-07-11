class AddGooglePlacesToPlaces < ActiveRecord::Migration[5.0]
  def change
	add_column :places, :google_place, :string, unique: true
  end
end
