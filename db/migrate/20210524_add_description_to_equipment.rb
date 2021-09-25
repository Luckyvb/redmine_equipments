class AddDescriptionToEquipment < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    add_column :equipments, :description, :text, null: true
  end

  def down
    remove_column :equipments, :description
  end
end
