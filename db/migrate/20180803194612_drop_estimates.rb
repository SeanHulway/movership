class DropEstimates < ActiveRecord::Migration[5.2]
  def change
  	drop_table :estimates
  end
end
