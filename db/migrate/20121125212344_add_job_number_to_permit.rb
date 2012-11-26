class AddJobNumberToPermit < ActiveRecord::Migration
  def up
    add_column :permits, :permit_job_number, :string
  end
  def down
    remove_column :permits, :permit_job_number
  end
end
