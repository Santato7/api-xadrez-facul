require_relative '../db/connection'

get '/api/v1/setup' do
  content_type :json

  begin
    sql = File.read('./db/setup.sql')
    DB.exec(sql)
    status 200
    { message: 'Banco de dados configurado com sucesso' }.to_json
  rescue PG::Error => e
    status 500
    { error: e.message }.to_json
  end
end