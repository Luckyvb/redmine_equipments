class CreateEmployeeTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :countries do |t|
      t.column :name, :string, null: false
      t.column :short_name, :string, null: false
      t.column :iso, :string, null: false

      t.index [:short_name], unique: false
      t.index [:iso], unique: true
    end
    create_table :cities do |t|
      t.references :country, null: false

      t.column :name, :string, null: false

      t.index [:country_id, :name], unique: false
    end

    add_column :addresses, :city_id, :int
    execute <<-SQL
      insert into countries (name, short_name, iso) values('Country', 'Country', '-');
    SQL
    execute <<-SQL
      Insert Into cities (country_id, name) Values(1, 'City');
    SQL
    execute <<-SQL
      Update addresses Set city_id=1 Where city_id is null;
    SQL

    change_column :addresses, :city_id, :int, null: false
    #add_foreign_key :addresses, :cities
    add_index :addresses, [:city_id, :name]

    create_table :employees do |t|
      t.references :project, null: false, default: 0
      t.references :organization, null: false
      t.references :user, null: true
      t.references :location, polymorphic: true, null: false

      t.column :full_name, :string
      t.column :description, :string
    end
  end

  def down
    delete_table :employees
    delete_table :cities
    delete_table :countries
  end
end
