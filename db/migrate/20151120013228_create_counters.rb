class CreateCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :counters do |t|
      t.string :name
      t.integer :ipv4_preload
      t.integer :ipv6_preload
      t.string :sti_type
      t.timestamps
    end
  end
end
