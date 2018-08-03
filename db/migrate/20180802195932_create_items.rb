class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :quantity
      t.belongs_to :room, foreign_key: true

      t.timestamps
    end
  end
end
