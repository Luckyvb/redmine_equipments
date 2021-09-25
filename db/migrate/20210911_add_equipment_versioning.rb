class AddEquipmentVersioning < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    Equipment.create_versioned_table
    add_index Equipment.versioned_table_name, :equipment_id, :name => :equipment_versions_equipment_id
    add_index Equipment.versioned_table_name, :number, :name => :equipment_versions_number
    add_index Equipment.versioned_table_name, :updated_at, :name => :index_equipment_versions_on_updated_at
  end

  def down
    Equipment.drop_versioned_table
    remove_column :equipments, :version
    remove_column :equipments, :version_comments
  end
end
