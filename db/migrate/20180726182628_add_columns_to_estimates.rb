class AddColumnsToEstimates < ActiveRecord::Migration[5.2]
  def change
    add_column :estimates, :phone, :string
    add_column :estimates, :email, :string
    add_column :estimates, :primary_contact, :string
    add_column :estimates, :start_type, :string
    add_column :estimates, :start_address, :string
    add_column :estimates, :start_city, :string
    add_column :estimates, :start_state, :string
    add_column :estimates, :start_zip, :string
    add_column :estimates, :destination_type, :string
    add_column :estimates, :destination_address, :string
    add_column :estimates, :destination_city, :string
    add_column :estimates, :destination_state, :string
    add_column :estimates, :destination_zip, :string
    add_column :estimates, :moving_date, :string
  end
end