class AddUpdaterToEquipment < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    add_column :equipments, :updater_id, :int

    add_index :equipments, [:project_id, :updater_id], unique: false
  end

  def down
    remove_column :equipments, :updater_id

    remove_index :equipments, [:project_id, :updater_id], unique: false
  end
end
