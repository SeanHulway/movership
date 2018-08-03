class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.belongs_to :build, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
