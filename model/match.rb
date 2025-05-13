require_relative '../db/connection'

module Match
  def self.all
    DB.exec("SELECT * FROM matches ORDER BY id").map { |row| symbolize(row) }
  end

  def self.find(id)
    result = DB.exec_params("SELECT * FROM matches WHERE id = $1 LIMIT 1", [id])
    result.ntuples > 0 ? symbolize(result[0]) : nil
  end

  def self.create(data)
    result = DB.exec_params(
      "INSERT INTO matches (white_player, black_player, result) VALUES ($1, $2, $3) RETURNING *",
      [data[:white_player], data[:black_player], data[:result]]
    )
    symbolize(result[0])
  end

  def self.update(id, data)
    DB.exec_params(
      "UPDATE matches SET white_player = $1, black_player = $2, result = $3 WHERE id = $4",
      [data[:white_player], data[:black_player], data[:result], id]
    )
  end

  def self.delete(id)
    DB.exec_params("DELETE FROM matches WHERE id = $1", [id])
  end

  def self.symbolize(row)
    row.transform_keys(&:to_sym)
  end
end
