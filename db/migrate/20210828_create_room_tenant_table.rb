class CreateRoomTenantTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :room_tenants do |t|
      t.references :room, null: false
      t.references :organization, null: false
      t.column :start_date, :date, null: false
      t.column :end_date, :date
      t.column :description, :text

      t.index [:room_id, :organization_id, :start_date], unique: true, name: "room_tenants_start"
      t.index [:room_id, :organization_id, :start_date, :end_date], unique: true, name: "room_tenants_start_end"
    end
  end

  def down
    delete_table :room_tenants
  end
end
