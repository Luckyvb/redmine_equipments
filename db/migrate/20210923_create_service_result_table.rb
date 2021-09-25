class CreateServiceResultTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    add_column :services, :document_number, :string, null: true

    create_table :service_result_types do |t|
      t.references :equipment_type, null: true
      t.references :service_type, null: true
      t.column :name, :string, null: false
      t.column :value_format, :string, null: false, default: 'string'
      t.column :description, :text

      t.index [:name], unique: false
      t.index [:equipment_type_id, :name], unique: false
      t.index [:equipment_type_id, :equipment_type, :name], unique: true
    end

    create_table :service_results do |t|
      t.references :service, null: false
      t.references :service_result_type, null: false
      t.column :date, :date, null: false
      t.references :responsible, :user, null: false, index: false
      t.column :value, :string, null: false
      t.column :description, :text

      t.index [:service_id, :service_result_type_id], unique: false
    end
  end

  def down
    remove_column :services, :document_number
    delete_table :service_results
    delete_table :service_result_types
  end
end
