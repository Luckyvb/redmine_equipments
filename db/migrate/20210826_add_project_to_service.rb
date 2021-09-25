class AddProjectToService < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    add_column :services, :project_id, :int, default: 0, null: false
  end

  def down
    remove_column :services, :project_id
  end
end
