class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.string :check
      t.text :content
      t.string :address
      t.string :sti_type
      t.timestamps
    end
  end
end
