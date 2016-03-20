class AddPanelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paneluser, :boolean, default: false
  end
end
