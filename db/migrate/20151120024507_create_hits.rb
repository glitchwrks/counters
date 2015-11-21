class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.references :counter
      t.string :address
      t.boolean :ipv6
      t.timestamps
    end

    add_index :hits, :counter_id
  end
end
