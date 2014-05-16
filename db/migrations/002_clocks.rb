Sequel.migration do
  up do
    create_table(:clocks) do
      primary_key :id
      foreign_key :employee_id, :employees
      Integer     :total_hours
      DateTime    :clock_in,           null: false
      DateTime    :clock_out
      DateTime    :created_at,         null: false
      DateTime    :updated_at,         null: false
    end
  end

  down do
    drop_table(:clocks)
  end
end
