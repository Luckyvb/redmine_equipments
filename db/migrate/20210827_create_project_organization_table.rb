class CreateProjectOrganizationTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :project_organizations do |t|
      t.references :project, null: false
      t.references :organization, null: false
      t.column :description, :text

      t.index [:project_id,:organization_id], unique: true, name: "project_organizations_main"
    end
  end

  def down
    delete_table :project_organizations
  end
end
