class AddScheduledTimeToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :when, :datetime
  end
end
