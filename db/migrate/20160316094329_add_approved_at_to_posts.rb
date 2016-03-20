class AddApprovedAtToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :approved_at, :datetime
  end
end
