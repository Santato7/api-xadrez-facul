require 'json'
require_relative '../models/match'

get '/api/v1/matches' do
  Match.all.to_json
end

get '/api/v1/matches/:id' do
  match = Match.find(params[:id].to_i)
  halt 404, { error: 'Match not found' }.to_json unless match
  match.to_json
end

post '/api/v1/matches' do
  begin
    data = JSON.parse(request.body.read, symbolize_names: true)
    match = Match.create(data)

    status 201
    match.to_json
  rescue PG::ForeignKeyViolation => e
    status 422
    { error: 'Chave estrangeira inválida. Verifique se os players existem.', detail: e.message }.to_json
  rescue JSON::ParserError
    status 400
    { error: 'JSON inválido' }.to_json
  end
end

put '/api/v1/matches/:id' do
  data = JSON.parse(request.body.read, symbolize_names: true)
  
  match = Match.update(params[:id].to_i, data)
  if match.nil?
    halt 404, { error: 'Match not found' }.to_json
  end

  { success: true }.to_json
end

patch '/api/v1/matches/:id' do
  data = JSON.parse(request.body.read, symbolize_names: true)

  updated = Match.update_partial(params[:id].to_i, data)
  if updated
    status 200
    { success: true }.to_json
  else
    halt 404, { error: 'Match not found' }.to_json
  end
end


delete '/api/v1/matches/:id' do
  Match.delete(params[:id].to_i)
  status 204
end
