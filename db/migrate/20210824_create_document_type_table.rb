class CreateDocumentTypeTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :document_types do |t|
      t.column :name, :string, null: false
      t.column :description, :text

      t.index [:name], unique: false
    end
  end

  def down
    delete_table :document_types
  end
end
