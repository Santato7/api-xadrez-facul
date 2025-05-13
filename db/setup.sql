CREATE TABLE matches (
  id SERIAL PRIMARY KEY,
  white_player VARCHAR(100),
  black_player VARCHAR(100),
  result VARCHAR(10) -- Ex: '1-0', '0-1', '½-½'
);
