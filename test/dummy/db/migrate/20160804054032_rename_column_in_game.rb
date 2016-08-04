class RenameColumnInGame < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :config, :config_json
  end
end
