class AddIndexOnCounterName < ActiveRecord::Migration
  def change
    add_index :counters, :name
  end
end