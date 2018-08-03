class CreateBuilds < ActiveRecord::Migration[5.2]
  def change
    create_table :builds, id: false do |t|
      t.string :id, :limit => 36, :primary_key => true
      t.string :name
      t.text :description
      t.string :phone
	    t.string :email
	    t.string :primary_contact
	    t.string :start_type
	    t.string :start_address
	    t.string :start_city
	    t.string :start_state
	    t.string :start_zip
	    t.string :destination_type
	    t.string :destination_address
	    t.string :destination_city
	    t.string :destination_state
	    t.string :destination_zip
	    t.string :moving_date

      t.timestamps
    end
  end
end
