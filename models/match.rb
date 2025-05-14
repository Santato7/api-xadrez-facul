require_relative '../db/connection'

module Match
  def self.all
    DB.exec('SELECT * FROM "MATCH" ORDER BY "MATCH_ID"').map { |row| symbolize(row) }
  end

  def self.find(id)
    result = DB.exec_params('SELECT * FROM "MATCH" WHERE "MATCH_ID" = $1 LIMIT 1', [id])
    result.ntuples > 0 ? symbolize(result[0]) : nil
  end

  def self.create(data)
    result = DB.exec_params(
      'INSERT INTO "MATCH" ("PLAYER_1_ID", "PLAYER_2_ID", "IS_DRAW", "GAME_MODE", "WINNER_ID", "START_DATETIME", "END_DATETIME")
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *',
      [
        data[:player_1_id],
        data[:player_2_id],
        data[:is_draw],
        data[:game_mode],
        data[:winner_id],
        data[:start_datetime],
        data[:end_datetime]
      ]
    )
    symbolize(result[0])
  end

  def self.update(id, data)
    match = find(id)
    return nil unless match
  
    DB.exec_params(
      'UPDATE "MATCH"
       SET "PLAYER_1_ID" = $1,
           "PLAYER_2_ID" = $2,
           "IS_DRAW" = $3,
           "GAME_MODE" = $4,
           "WINNER_ID" = $5,
           "START_DATETIME" = $6,
           "END_DATETIME" = $7
       WHERE "MATCH_ID" = $8',
      [
        data[:player_1_id],
        data[:player_2_id],
        data[:is_draw],
        data[:game_mode],
        data[:winner_id],
        data[:start_datetime],
        data[:end_datetime],
        id
      ]
    )
  end

  def self.update_partial(id, data)
    return false if data.empty?
  
    set_clause = data.keys.map.with_index { |key, i| "\"#{key.to_s.upcase}\" = $#{i + 1}" }.join(', ')
    values = data.values
    values << id
  
    result = DB.exec_params(
      "UPDATE \"MATCH\" SET #{set_clause} WHERE \"MATCH_ID\" = $#{values.length}",
      values
    )
    result.cmd_tuples > 0
  end
  

  def self.delete(id)
    DB.exec_params('DELETE FROM "MATCH" WHERE "MATCH_ID" = $1', [id])
  end

  def self.symbolize(row)
    row.transform_keys(&:to_sym)
  end
end
