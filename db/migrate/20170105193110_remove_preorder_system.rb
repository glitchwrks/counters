class RemovePreorderSystem < ActiveRecord::Migration

  def up
    drop_table :preorders
    drop_table :projects
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end