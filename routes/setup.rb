require_relative '../db/connection'

get '/setup' do
  begin
    sql = File.read('./db/setup.sql')
    DB.exec(sql)
    status 200
  rescue PG::Error => e
    status 500
    { error: e.message }.to_json
  end
end