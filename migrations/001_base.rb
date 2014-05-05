Sequel.migration do
  up do
    create_table(:joels) do
      primary_key :id
      String      :url, null: false
      index       :url, unique: true
    end
  end

  down do
    drop_table(:joels)
  end
end
