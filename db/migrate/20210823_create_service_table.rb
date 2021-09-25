class CreateServiceTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :services do |t|
      t.references :equipment, null: false
      t.references :organization, null: false
      t.references :service_type, null: false
      t.column :start_date, :date, null: false
      t.column :end_date, :date, null: true
      t.references :send_by, :user, null: false, index: false
      t.references :return_by, :user, null: true, index: false
      t.column :description, :text

      t.index [:start_date], unique: false
      t.index [:end_date], unique: false
      t.index [:send_by_id], unique: false
      t.index [:return_by_id], unique: false
      t.index [:equipment_id, :organization_id], unique: false
      t.index [:equipment_id, :service_type_id], unique: false
      t.index [:equipment_id, :organization_id, :start_date, :end_date], unique: false, name: "service_equipment_history"
    end
  end

  def down
    delete_table :services
  end
end
