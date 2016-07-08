class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string :attachment_id, null: false
      t.string :attachment_filename
      t.integer :attachment_size
      t.string :attachment_content_type

      t.timestamps
    end
  end
end
