Sequel.migration do
  up do
    alter_table(:joels) do
      add_column :tags, 'text[]', default: "{}"
    end
  end

  down do
    alter_table(:joels) do
      drop_column(:joels)
    end
  end
end
