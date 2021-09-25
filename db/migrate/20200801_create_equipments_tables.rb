class CreateEquipmentsTables < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def change
    create_table :equipment_types do |t|
      t.column :name, :string, null: false
      t.column :number_template, :string
      t.position :position, :int
      t.column :ancestry, :string

      t.index [:name], unique: false
      t.index [:ancestry], unique: false
    end

    create_table :vendors do |t|
      t.column :name, :string, null: false
      t.column :icon, :string
      t.column :site, :string

      t.index [:name], unique: false
    end

    create_table :vendor_models do |t|
      t.references :equipment_type, null: false
      t.references :vendor, null: false
      t.column :name, :string, null: false
      t.column :pn, :string
      t.column :site, :string

      t.index [:vendor_id, :name], unique: false
      t.index [:equipment_type_id, :vendor_id, :name], unique: false
    end

    create_table :organizations do |t|
      t.column :name, :string, null: false
      t.column :site, :string
      t.column :ancestry, :string

      t.index [:name], unique: false
      t.index [:ancestry], unique: false
    end

    create_table :address do |t|
      t.column :name, :string, null: false
      t.column :coordinates, :string

      t.index [:name], unique: false
    end

    create_table :floor do |t|
      t.references :address, null: false

      t.column :number, :int, null: false
      t.column :name, :string

      t.index [:address], [:number], unique: false
    end

    create_table :room do |t|
      t.references :floor, null: false

      t.column :number, :int, null: false
      t.column :name, :string

      t.index [:floor], [:number], unique: false
    end

    create_table :attributes do |t|
      t.column :name, :string
      t.column :description, :text

      t.index [:name], unique: true
    end

    create_table :attribute_values do |t|
      t.references :attributable, polymorphic: true, null: false
      t.references :attribute, null: false

      t.column :attribute_value, :string

      t.index [:attributable_type, :attributable_id], unique: false
      t.index [:owner_type, :owner_id], unique: false
      t.index [:owner_type, :owner_id, :attribute_id], unique: false
      t.index [:attribute_id], unique: false
      t.index [:attribute_value], unique: false
    end

    create_table :equipments do |t|
      t.references :organization, null: false
      t.references :equipment_type, null: false
      t.references :vendor_model, null: false
      t.references :owner, polymorphic: true, null: false
      t.references :location, polymorphic: true, null: false

      t.column :number, :string
      t.column :sn, :string
      t.column :warranty_end, :datetime
      t.column :ancestry, :string
      t.timestamps

      t.index :ancestry
      t.index [:organization_id, :equipment_type_id, :vendor_model_id], unique: false, name: "equipment_org_eq_type_vm"
      t.index [:organization_id, :owner_type, :owner_id], unique: false
      t.index [:organization_id, :location_type, :location_id], unique: false
      t.index [:organization_id, :number], unique: false
      t.index [:organization_id, :sn], unique: true
    end

  end
end
