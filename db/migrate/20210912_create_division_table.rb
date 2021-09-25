class CreateDivisionTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :divisions do |t|
      t.references :project, null: false, default: 0
      t.references :organization, null: false
      t.references :group, null: true
      t.references :location, polymorphic: true, null: false

      t.column :name, :string
      t.column :description, :string
    end
  end

  def down
    delete_table :divisions
  end
end
