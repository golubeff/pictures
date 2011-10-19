class CreateImportLogs < ActiveRecord::Migration
  def up
    create_table :import_logs do |t|
      t.string :key
      t.string :url
      t.timestamps
    end
    add_index :import_logs, :key
  end

  def down
    drop_table :import_logs
  end
end
