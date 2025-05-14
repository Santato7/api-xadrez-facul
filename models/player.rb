require_relative '../db/connection'

module Player
  def self.all
    DB.exec('SELECT "PLAYER_ID", "FIRST_NAME", "LAST_NAME", "USERNAME", "EMAIL", "REGISTRATION_DATE" FROM "PLAYER" ORDER BY "PLAYER_ID"').map { |row| symbolize(row) }
  end

  def self.find(id)
    result = DB.exec_params('SELECT * FROM "PLAYER" WHERE "PLAYER_ID" = $1 LIMIT 1', [id])
    result.ntuples > 0 ? symbolize(result[0]) : nil
  end

  def self.create(data)
    result = DB.exec_params(
      'INSERT INTO "PLAYER" ("FIRST_NAME", "LAST_NAME", "USERNAME", "PASSWORD", "EMAIL") VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [data[:first_name], data[:last_name], data[:username], data[:password], data[:email]]
    )
    symbolize(result[0])
  end

  def self.update(id, data)
    player = find(id)
    return nil unless player

    DB.exec_params(
      'UPDATE "PLAYER" SET "FIRST_NAME" = $1, "LAST_NAME" = $2, "USERNAME" = $3, "PASSWORD" = $4, "EMAIL" = $5 WHERE "PLAYER_ID" = $6',
      [data[:first_name], data[:last_name], data[:username], data[:password], data[:email], id]
    )
  end

  def self.update_partial(id, data)
    return false if data.empty?
  
    set_clause = data.keys.map.with_index { |key, i| "\"#{key.to_s.upcase}\" = $#{i + 1}" }.join(', ')
    values = data.values
    values << id
  
    result = DB.exec_params(
      "UPDATE \"PLAYER\" SET #{set_clause} WHERE \"PLAYER_ID\" = $#{values.length}",
      values
    )
    result.cmd_tuples > 0
  end
  

  def self.delete(id)
    DB.exec_params('DELETE FROM "PLAYER" WHERE "PLAYER_ID" = $1', [id])
  end

  def self.symbolize(row)
    row.transform_keys(&:to_sym)
  end
end
