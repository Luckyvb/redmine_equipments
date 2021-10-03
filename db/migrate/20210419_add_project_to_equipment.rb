class AddProjectToEquipment < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    add_column :equipments, :project_id, :int, default: 0, null: false, after: :organization_id

    add_index :equipments, [:project_id, :equipment_type_id, :vendor_model_id], unique: false, name: "equipment_prj_eq_type_vm"
    add_index :equipments, [:project_id, :owner_type, :owner_id], unique: false
    add_index :equipments, [:project_id, :location_type, :location_id], unique: false
    add_index :equipments, [:project_id, :number], unique: false
    add_index :equipments, [:project_id, :sn], unique: true
  end

  def down
    remove_column :equipments, :project_id

    remove_index :equipments, [:project_id, :equipment_type_id, :vendor_model_id], unique: false, name: "equipment_prj_eq_type_vm"
    remove_index :equipments, [:project_id, :owner_type, :owner_id], unique: false
    remove_index :equipments, [:project_id, :location_type, :location_id], unique: false
    remove_index :equipments, [:project_id, :number], unique: false
    remove_index :equipments, [:project_id, :sn], unique: true
  end
end
