class CreateConsignmentNoteTable < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[5.0]
  def up
    create_table :consignment_notes do |t|
      t.references :project, null: false
      t.references :organization, null: false
      t.references :seller, :organization, null: false, index: false
      t.references :document_type, null: false
      t.column :number, :string, null: false
      t.column :date, :date, null: false
      t.column :is_locked, :bool, null: false, default: false
      t.column :total, :float
      t.column :description, :text

      t.index [:number, :date], unique: false
      t.index [:seller_id], unique: false
      t.index [:organization_id, :seller_id, :document_type_id, :number, :date], unique: true, name: "consignment_note_main"
    end
  end

  def down
    delete_table :consignment_notes
  end
end
