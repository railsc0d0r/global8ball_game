class RemoveColumnUserIdFromPlayer < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :user_id
  end
end
