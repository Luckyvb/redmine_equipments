class CreateStoreTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :stores do |t|
      t.references :project, null: false
      t.references :organization, null: false
      t.column :name, :string, null: false
      t.references :location, polymorphic: true, null: false
      t.column :is_abstract, :bool, null: false, default: false
      t.references :responsible, polymorphic: true, null: false
      t.column :ancestry, :string

      t.index [:name], unique: false
      t.index [:ancestry], unique: true
      t.index [:organization_id, :location_type, :location_id], unique: false, name: "stores_location"
    end
  end

  def down
    delete_table :stores
  end
end
