class MigrateDataIntoNewTwoTableArchitecture < ActiveRecord::Migration
  def up
   change_column :secondary_suggestions, :primary_suggestion_id, :integer, null: true
    execute <<-SQL
      INSERT INTO
        primary_suggestions (
          suggestion_id,
          created_at,
          updated_at,
          description,
          event_id)
      SELECT
        id,
        created_at,
        updated_at,
        "primary",
        event_id
      FROM
        suggestions
    SQL

    execute <<-SQL
      INSERT INTO
        secondary_suggestions (
          suggestion_id,
          created_at,
          updated_at,
          description)
      SELECT
        id,
        created_at,
        updated_at,
        secondary
      FROM
        suggestions
      WHERE
        secondary <> ''
    SQL

    execute <<-SQL
      UPDATE 
        secondary_suggestions ss
      SET 
        primary_suggestion_id = ps.id
      FROM 
        primary_suggestions ps
      WHERE 
        ps.suggestion_id = ss.suggestion_id;
    SQL

    execute <<-SQL
      UPDATE 
        votes v
      SET 
        new_suggestion_id = ps.id,
        new_suggestion_type = 'PrimarySuggestion',
        event_id = ps.event_id
      FROM 
        primary_suggestions ps
      WHERE 
        ps.suggestion_id = v.suggestion_id
    SQL

    execute <<-SQL
      UPDATE 
        votes v
      SET 
        new_suggestion_id = ss.id,
        new_suggestion_type = 'SecondarySuggestion',
        event_id = ps.event_id
      FROM 
        secondary_suggestions ss
      INNER JOIN 
        primary_suggestions ps on ps.id = ss.primary_suggestion_id
      WHERE 
        ss.suggestion_id = v.suggestion_id
    SQL
    change_column :secondary_suggestions, :primary_suggestion_id, :integer, null: false

    rename_table(:suggestions, :suggestions_deprecated)
    rename_column(:votes, :suggestion_id, :suggestion_id_deprecated)
    rename_column(:votes, :new_suggestion_id, :suggestion_id)
    rename_column(:votes, :new_suggestion_type, :suggestion_type)
    rename_column(:primary_suggestions, :suggestion_id, :suggestion_id_deprecated)
    rename_column(:secondary_suggestions, :suggestion_id, :suggestion_id_deprecated)
  end

  def down
    rename_table(:suggestions_deprecated, :suggestions)
    rename_column(:votes, :suggestion_id, :new_suggestion_id)
    rename_column(:votes, :suggestion_type, :new_suggestion_type)
    rename_column(:votes, :suggestion_id_deprecated, :suggestion_id)
    rename_column(:primary_suggestions, :suggestion_id_deprecated, :suggestion_id)
    rename_column(:secondary_suggestions, :suggestion_id_deprecated, :suggestion_id)
  end
end
