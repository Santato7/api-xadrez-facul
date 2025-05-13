require 'pg'
require 'dotenv/load'

DB = PG.connect(
  host:     ENV['DB_HOST'],
  port:     ENV['DB_PORT'],
  dbname:   ENV['DB_NAME'],
  user:     ENV['DB_USER'],
  password: ENV['DB_PASSWORD']
)
