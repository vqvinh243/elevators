class CreateOutsideRequests < ActiveRecord::Migration
  def change
    create_table :outside_requests do |t|
      t.integer :floor
      t.string :direction

      t.timestamps
    end
  end
end
