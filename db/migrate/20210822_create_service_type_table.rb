class CreateServiceTypeTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :service_types do |t|
      t.column :name, :string, null: false
      t.column :description, :text

      t.index [:name], unique: false
    end
  end

  def down
    delete_table :service_types
  end
end
