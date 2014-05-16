Sequel.migration do
  up do
    create_table(:employees) do
      primary_key :id
      Integer     :rut,                null: false, unique: true
      String      :cv,                 size: 1, null: false
      String      :name,               size: 255, null: false
      String      :last_name,          size: 255, null: false
      Boolean     :active,             null: false, default: true
      DateTime    :created_at,         null: false
      DateTime    :updated_at,         null: false
    end
  end

  down do
    drop_table(:employees)
  end
end
